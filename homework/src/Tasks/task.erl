%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Jun 2019 14:41
%%%-------------------------------------------------------------------
-module(task).
-author("knikolov").

-define(ZERO_CODE, 48).
-define(NINE_CODE, 57).
-define(SPACE_CODE, 32).

-define(IS_NUMBER(H),
  (H >= ?ZERO_CODE andalso H =< ?NINE_CODE) orelse H =:= 46 orelse (H >= 65 andalso H =< 90)
).

-record(event, {
  id = new,
  pid = nil,
  name,
  description,
  time_out,
  repeat = 0
}).

%%-define(IS_NUMBER, (H >= ?ZERO_CODE andalso H =< ?NINE_CODE) orelse H =:= 46 orelse (H >= 65 andalso H =< 90)).

%% API
-export([test/0, start/0]).

test() -> [].

start() ->
  Empty = orddict:new(),
  One = orddict:store(1, #event{name = "test", repeat = 2}, Empty),
  Two = orddict:store(2, #event{name = "test", repeat = 2}, One),
  Three = orddict:store(3, #event{name = "test", repeat = 2}, Two),
  io:fwrite("~p~n", [updatedict(2, Three)]),
  ok.

check([HA | T]) when ?IS_NUMBER(HA) ->
  number;
check(N) ->
  hmm.

caseof(A) ->
  case A of
    0 -> zero;
    B -> B + 2
  end.

updatedict(EventId, Events) ->
  case orddict:find(EventId, Events) of
    {ok, Event = #event{}} ->
      case Event#event.repeat of
        0 -> orddict:erase(EventId, Events);
        Repeat -> orddict:update(EventId, fun(Event) -> Event#event{repeat = Repeat - 1} end, Events)
      end;
    error ->
      Events
  end.

