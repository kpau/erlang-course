%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Jun 2019 16:46
%%%-------------------------------------------------------------------
-module(helloworld).
-author("knikolov").

-include("../../Test/assertion.hrl").

%% API
-export([test/0, hello/1]).

test() -> [
  ?assertEqual("Hello Kiro!", greeting_msg("Kiro"))
].

hello(Name) ->
  io:fwrite("~s! ~n", [greeting_msg(Name)]).

greeting_msg(Name) -> "Hello " ++ Name ++ "!".