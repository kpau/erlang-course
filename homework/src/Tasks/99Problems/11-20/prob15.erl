%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob15).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, repli/2]).

test() -> [
  ?assertEqual([], repli([], 3)),
  ?assertEqual([1, 1], repli([1], 2)),
  ?assertEqual([1], repli([1], 1)),
  ?assertEqual([1, 1, 1, 1], repli([1], 4)),
  ?assertEqual([1, 1, 1, 2, 2, 2, 3, 3, 3], repli([1, 2, 3], 3)),
  ?assertEqual("aaaassssdddd", repli("asd", 4)),
  ?assertEqual([a, a, s, s, d, d], repli([a, s, d], 2))
  ].

%% Problem 15
%% (**) Replicate the elements of a list a given number of times.

repli(Input, N) -> lists:reverse(repli(Input, N, N, [])).

repli([], _, _, Result) -> Result;
repli([H | T], N, 1, Result) ->
  repli(T, N, N, [H | Result]);
repli(Input = [H | _], N, CurN, Result) ->
  repli(Input, N, CurN - 1, [H | Result]).
