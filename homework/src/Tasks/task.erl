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

%% API
-export([test/0, start/0]).

test() -> [].

start() ->
  io:fwrite("~9.5.0w~n",[3]),
%%  io:fwrite(" > ~-20.20ptest~n", [5]),
  io:format("~-40.40s tests~n", ["./Tasks//99Problems/01-10/prob01.erl"]),
  ok.
