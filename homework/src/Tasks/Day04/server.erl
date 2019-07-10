%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Jul 2019 17:47
%%%-------------------------------------------------------------------
-module(server).
-author("knikolov").
-include_lib("../../Test/assertion.hrl").

-record(state, {
  clients,
  events,
  event_max_id = 0
}).

-record(event, {
  id = new,
  pid = nil,
  name,
  description,
  time_out,
  repeat = 0
}).

-define(TIMEOUT, 5000).

%% API
-export([test/0, start/0, start_link/0, init/0, subscribe/0, update/0, shutdown/0, add/1, cancel/1, listen/0, listen/1, listen/2]).

test() -> [
  ?assertNotException(start()),
  ?assertNotException(shutdown()),

  ?assertNotException(start()),

  ?assertEqual(ok, element(1, subscribe())),

  ?assertEqual({ok, #event{id = 1, name = "test", time_out = 1, description = "asd"}},
    add(#event{name = "test", time_out = 1, description = "asd"})),

  ?assertReceive(2000, {done, #event{name = "new", time_out = 1, description = "des"}}, add(#event{name = "new", time_out = 1, description = "des"})),

  ?assertEqual({ok, 3},
    (fun() ->
      add(#event{name = "next", time_out = 10, description = "ddd"}),
      cancel(3)
     end)())
].

start() ->
  register(?MODULE, Pid = spawn(?MODULE, init, [])),
  Pid.

start_link() ->
  register(?MODULE, Pid = spawn_link(?MODULE, init, [])),
  Pid.

update() ->
  ?MODULE ! update.

shutdown() ->
  ?MODULE ! shutdown,
  unregister(?MODULE).

subscribe() ->
  subscribe(self()).

subscribe(SubscriberPid) ->
  Ref = monitor(process, whereis(?MODULE)),
  ?MODULE ! {self(), Ref, {subscribe, SubscriberPid}},
  receive
    {Ref, ok} ->
      {ok, Ref};
    {'DOWN', Ref, process, Pid, Reason} ->
      {error, Reason}
  after ?TIMEOUT ->
    {error, timeout}
  end.

add(Event = #event{id = new}) ->
  MsgRef = make_ref(),
  ?MODULE ! {self(), MsgRef, {add, Event}},
  receive
    {MsgRef, ok, EventId} ->
      {ok, Event#event{id = EventId}}
  after ?TIMEOUT ->
    {error, timeout}
  end.

cancel(#event{id = EventId}) when EventId =/= new ->
  cancel(EventId);
cancel(EventId) ->
  MsgRef = make_ref(),
  ?MODULE ! {self(), MsgRef, {cancel, EventId}},
  receive
    {MsgRef, ok} -> {ok, EventId}
  after ?TIMEOUT ->
    {error, timeout}
  end.

listen() ->
  listen(0).

listen(Delay) ->
  receive
    {done, Event = #event{}} ->
      [Event | listen()]
  after Delay * 1000 ->
    []
  end.

listen(Delay, EventId) ->
  receive
    {done, Event = #event{id = EventId}} ->
      [Event | listen()]
  after Delay * 1000 ->
    []
  end.

init() ->
  State = #state{
    clients = orddict:new(),
    events = orddict:new(),
    event_max_id = 0
  },
  loop(State).

loop(State = #state{}) ->
  receive
    update ->
      ?MODULE:update(State);
    {Sender, MsgRef, {subscribe, ClientPid}} ->
      NewState = add_subscriber(State, ClientPid),
      Sender ! {MsgRef, ok},
      loop(NewState);
    {Sender, MsgRef, {add, Event = #event{id = new}}} ->
      NewState = add_event(State, Event),
      Sender ! {MsgRef, ok, NewState#state.event_max_id},
      loop(NewState);
    {Sender, MsgRef, {cancel, EventId}} ->
      NewState = cancel_event(State, EventId),
      Sender ! {MsgRef, ok},
      loop(NewState);
    {done, EventId} ->
      NewState = done_event(State, EventId),
      loop(NewState);
    {'DOWN', Ref, process, Pid, Reason} ->
      NewState = remove_subscriber(State, Ref),
      loop(NewState);
    shutdown ->
      shutdown(State);
    Unknown ->
      io:format("Unknown message: ~p~n", [Unknown]),
      loop(State)
  end,
  ok.

update(State) ->
  loop(State).

add_subscriber(State, ClientPid) ->
  ClientRef = monitor(process, ClientPid),
  NewClients = orddict:store(ClientRef, ClientPid, State#state.clients),
  State#state{clients = NewClients}.

remove_subscriber(State, ClientRef) ->
  NewClients =
    case orddict:find(ClientRef, State#state.clients) of
      {ok, _} ->
        orddict:erase(ClientRef, State#state.clients);
      error ->
        State#state.clients
    end,
  State#state{clients = NewClients}.

add_event(State, Event = #event{id = new}) ->
  NewEventId = State#state.event_max_id + 1,
  NewEventPid = event:start_link(NewEventId, Event#event.time_out),
  NewEvent = Event#event{id = NewEventId, pid = NewEventPid},
  NewEvents = orddict:store(NewEventId, NewEvent, State#state.events),
  State#state{events = NewEvents, event_max_id = NewEventId}.

cancel_event(State, EventId) ->
  NewEvents =
    case orddict:find(EventId, State#state.events) of
      {ok, #event{pid = EventPid}} ->
        event:cancel(EventPid),
        orddict:erase(EventId, State#state.events);
      error ->
        State#state.events
    end,
  State#state{events = NewEvents}.

done_event(State, EventId) ->
  NewEvents =
    case orddict:find(EventId, State#state.events) of
      {ok, Event = #event{}} ->
        orddict:map(fun(_Ref, Pid) ->
          Pid ! {done, Event} end, State#state.clients),

        orddict:erase(EventId, State#state.events);
      error ->
        State#state.events
    end,
  State#state{events = NewEvents}.

shutdown(State) ->
  exit(shutdown).

