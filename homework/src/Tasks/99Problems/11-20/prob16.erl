%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob16).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, drop/2]).

test() -> [
  ?assertEqual([], drop([], 1)),
  ?assertEqual([1], drop([1], 2)),
  ?assertEqual([], drop([1], 1)),
  ?assertEqual([1, 3], drop([1, 2, 3, 4], 2)),
  ?assertEqual([], drop([1, 2, 3, 4, 5, 6, 7], 1)),
  ?assertEqual([1, 2, 4, 5, 7], drop([1, 2, 3, 4, 5, 6, 7], 3)),
  ?assertEqual("ad", drop("asd", 2)),
  ?assertEqual([a, d], drop([a, s, d], 2))
  ].

%% Problem 16
%% (**) Drop every N'th element from a list.

drop(Input, N) -> lists:reverse(drop(Input, N, N, [])).

drop([], _, _, Result) -> Result;
drop([H | T], N, 1, Result) ->
  drop(T, N, N, Result);
drop([H | T], N, CurN, Result) ->
  drop(T, N, CurN - 1, [H | Result]).
