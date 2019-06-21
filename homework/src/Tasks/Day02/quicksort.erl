%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Jun 2019 16:54
%%%-------------------------------------------------------------------
-module(quicksort).
-author("knikolov").
-include_lib("../../Test/assertion.hrl").

%% API
-export([test/0, sort/1]).

test() -> [
  ?assertEqual([], sort([])),
  ?assertEqual([1], sort([1])),
  ?assertEqual([1, 2], sort([1, 2])),
  ?assertEqual([1, 2], sort([2, 1])),
  ?assertEqual([1, 2, 3, 4, 5], sort([3, 2, 1, 5, 4])),
  ?assertEqual([1, 2, 2, 3, 4, 4, 4, 5], sort([2, 3, 4, 2, 1, 4, 5, 4])),
  ?assertEqual("abcde", sort("badce")),
  ?assertEqual("aabcccdeeee", sort("ccbeaeedcea"))
].

%% Implement merge sort.
sort(List) -> quicksort(List).

quicksort([]) -> [];
quicksort([El]) -> [El];
quicksort([Pivot | T]) ->
  {Smaller, Bigger} = partition(Pivot, T, [], []),
  quicksort(Smaller) ++ [Pivot] ++ quicksort(Bigger).

partition(Pivot, [], Smaller, Bigger) -> { Smaller, Bigger };
partition(Pivot, List = [H | T], Smaller, Bigger) when H < Pivot ->
  partition(Pivot, T, [H | Smaller], Bigger);
partition(Pivot, List = [H | T], Smaller, Bigger) when H >= Pivot ->
  partition(Pivot, T, Smaller, [H | Bigger]).
