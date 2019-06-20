%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:59
%%%-------------------------------------------------------------------
-define(assertEqual(Expect, Expr),
  begin
    ((fun (__X) ->
      case (Expr) of
        __X -> { pass,
          {
            assertEqual,
            {module, ?MODULE},
            {line, ?LINE},
            {expression, (??Expr)},
            {expected, __X},
            {value, __X}
          }};
        __V -> { fail,
          {
            assertEqual,
            {module, ?MODULE},
            {line, ?LINE},
            {expression, (??Expr)},
            {expected, __X},
            {value, __V}
          }}
      end
      end)(Expect))
  end).

%%%% API
%%-export([equal/2]).
%%
%%equal(X, Y) -> result(equal, [X, Y], X == Y).
%%
%%result(_, _, true) -> ok;
%%result(Assertion, Params, Result) ->
%%  print(Assertion, Params, Result),
%%  ok.
%%
%%
%%print(Assertion, Params, Result) ->
%%  io:format("~p: ~p ~p~n", [message(Result), Assertion, Params]).
%%
%%message(true) -> ok;
%%message(false) -> fail.

