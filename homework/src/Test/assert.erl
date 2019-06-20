%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:59
%%%-------------------------------------------------------------------
-module(assert).
-author("knikolov").

%% API
-export([equal/2]).

equal(X, Y) -> result(equal, [X, Y], X == Y).

result(_, _, true) -> ok;
result(Assertion, Params, Result) ->
  print(Assertion, Params, Result),
  ok.


print(Assertion, Params, Result) ->
  io:format("~p: ~p ~p~n", [message(Result), Assertion, Params]).

message(true) -> ok;
message(false) -> fail.

