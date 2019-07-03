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

%%-define(IS_NUMBER, (H >= ?ZERO_CODE andalso H =< ?NINE_CODE) orelse H =:= 46 orelse (H >= 65 andalso H =< 90)).

%% API
-export([test/0, start/0]).

test() -> [].

start() ->
  io:fwrite("~p~n",[check("5a")]),
  io:fwrite("~p~n",[check("a5")]),
  ok.

check([HA | T]) when ?IS_NUMBER(HA) ->
  number;
check(N) ->
  hmm.
