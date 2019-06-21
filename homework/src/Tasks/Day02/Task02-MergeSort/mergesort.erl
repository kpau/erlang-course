%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Jun 2019 16:54
%%%-------------------------------------------------------------------
-module(mergesort).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

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
sort(List) -> lists:reverse(mergesort(List)).

mergesort([]) -> [];
mergesort([E]) -> [E];
mergesort(List) ->
  {Left, Right} = split(List),
  merge(mergesort(Left), mergesort(Right)).


split(List) ->
  {Left, Right} = split(List, List, []),
  {lists:reverse(Left), Right}.

split([], RestList, Left) -> {Left, RestList};
split([_], RestList, Left) -> {Left, RestList};
split([_, _ | Iterate], [H | T], Left) ->
  split(Iterate, T, [H | Left]).

merge(Left, Right) -> merge(lists:reverse(Left), lists:reverse(Right), []).

merge([], [], Result) -> Result;
merge([HL | TL], [], Result) ->
  merge(TL, [], [HL | Result]);
merge([], [HR | TR], Result) ->
  merge([], TR, [HR | Result]);
merge([HL | TL], Right = [HR | _], Result) when HL =< HR ->
  merge(TL, Right, [HL | Result]);
merge(Left = [HL | _], [HR | TR], Result) when HL > HR ->
  merge(Left, TR, [HR | Result]).
