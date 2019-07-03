%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob17).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, split/2]).

test() -> [
  ?assertEqual({[1], [2]}, split([1, 2], 1)),
  ?assertEqual({[1, 2], [3, 4]}, split([1, 2, 3, 4], 2)),
  ?assertEqual({[], [1, 2, 3, 4]}, split([1, 2, 3, 4], 0)),
  ?assertEqual({[1, 2, 3, 4], []}, split([1, 2, 3, 4], 4)),
  ?assertEqual({"abc", "de"}, split("abcde", 3)),
  ?assertEqual({[a, s], [d]}, split([a, s, d], 2))
  ].

%% Problem 17
%% (*) Split a list into two parts; the length of the first part is given.
%% Do not use any predefined predicates.

split(Input, N) -> split(Input, N, []).

split(Input , 0, FirstPart) -> {lists:reverse(FirstPart), Input};
split([H | T], CurN, FirstPart) ->
  split(T, CurN - 1, [H | FirstPart]).