%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob06).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, is_palindrome/1]).


test() -> [
  ?assertEqual(true, is_palindrome([])),
  ?assertEqual(true, is_palindrome([2])),
  ?assertEqual(true, is_palindrome([4, 2, 2, 4])),
  ?assertEqual(false, is_palindrome([4, 2, 3, 4])),
  ?assertEqual(false, is_palindrome([1, 3, 3, 4])),
  ?assertEqual(false, is_palindrome("dsad")),
  ?assertEqual(true, is_palindrome("dsasd")),
  ?assertEqual(false, is_palindrome([d, s, a])),
  ?assertEqual(true, is_palindrome([a, s, a])),
  ?assertEqual(false, is_palindrome([1, "a", a])),
  ?assertEqual(true, is_palindrome([1, "a", a, "a", 1]))
].

%% Problem 6
%% (*) Find out whether a list is a palindrome. A palindrome can be read forward or backward; e.g. (x a m a x).

is_palindrome(List) ->
  {FirstReversed, Second} = split(List, List, []),
  FirstReversed =:= Second.

split([], ListRemaining, FirstReversed) -> {FirstReversed, ListRemaining};
split([_], [_ | ListRemaining], FirstReversed) -> {FirstReversed, ListRemaining};
split([_, _ | Iterate], [H | T], FirstReversed) ->
  split(Iterate, T, [H | FirstReversed]).
