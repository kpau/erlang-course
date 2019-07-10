%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Jul 2019 10:02
%%%-------------------------------------------------------------------
-module(event).
-author("knikolov").
-include_lib("../../Test/assertion.hrl").

-record(state, {
  server,
  id,
  time = 0
}).

%% API
-export([test/0, start/2, start_link/2, cancel/1, init/3]).

test() -> [
  ?assertNotException(start(1, 5)),

  ?assertNotException(start_link(2, 3)),

  ?assertEqual(ok,
    (fun() ->
      Pid = start(1, 10),
      cancel(Pid)
     end)()),


  ?assertEqual(down,
    (fun() ->
      start(2, 10),
      PidInvalid = spawn(fun() -> ok end),
      cancel(PidInvalid)
     end)()),

  ?assertReceive(1000, {done, 3}, start(3, 0)),

  ?assertNotReceive(1000, {done, 4}, start(4, 2))
].

start(EventId, Time) ->
  spawn(?MODULE, init, [self(), EventId, Time]).

start_link(EventId, Time) ->
  spawn_link(?MODULE, init, [self(), EventId, Time]).

cancel(EventPid) ->
  Ref = monitor(process, EventPid),
  EventPid ! {self(), Ref, cancel},
  receive
    {Ref, ok} ->
      demonitor(Ref, [flush]),
      ok;
    {'DOWN', Ref, process, EventPid, _Reason} ->
      down
  end.


init(Server, EventId, Time) ->
  State = #state{
    server = Server,
    id = EventId,
    time = normalize(Time)
  },
  loop(State).

loop(S = #state{server = Server, time = [Time | TimeLeft]}) ->
  receive
    {Server, Ref, cancel} -> Server ! {Ref, ok}
  after Time * 1000 -> timeout(S#state{time = TimeLeft})
  end;
loop(S = #state{time = []}) ->
  loop(S#state{time = [0]});
loop(S = #state{time = TimeLeft}) ->
  loop(S#state{time = normalize(TimeLeft)}).

timeout(#state{server = Server, id = Id, time = []}) ->
  Server ! {done, Id};
timeout(S) ->
  loop(S).

%% Because Erlang is limited to about 49 days (49*24*60*60*1000) in
%% milliseconds, the following function is used
normalize(N) ->
  Limit = 49 * 24 * 60 * 60,
  [N rem Limit | lists:duplicate(N div Limit, Limit)].
