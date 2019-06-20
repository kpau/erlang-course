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
-export([test/0, isPalindrome/1]).


test() -> [
  ?assertEqual(true, isPalindrome([])),
  ?assertEqual(true, isPalindrome([2])),
  ?assertEqual(true, isPalindrome([4,2,2,4])),
  ?assertEqual(false, isPalindrome([4,2,3,4])),
  ?assertEqual(false, isPalindrome([1,3,3,4])),
  ?assertEqual(false, isPalindrome("dsad")),
  ?assertEqual(true, isPalindrome("dsasd")),
  ?assertEqual(false, isPalindrome([d,s,a])),
  ?assertEqual(true, isPalindrome([a,s,a])),
  ?assertEqual(false, isPalindrome([1, "a", a])),
  ?assertEqual(true, isPalindrome([1, "a", a, "a", 1]))
].

%% Problem 6
%% (*) Find out whether a list is a palindrome. A palindrome can be read forward or backward; e.g. (x a m a x).
isPalindrome(List) ->
  {FirstReversed, Second} = split(List, List, []),
  FirstReversed =:= Second.

split([], ListRemaining, FirstReversed) -> {FirstReversed, ListRemaining};
split([_], [_ | ListRemaining], FirstReversed) -> {FirstReversed, ListRemaining};
split([_, _ | Iterate], [H | T], FirstReversed) ->
  split(Iterate, T, [H | FirstReversed]).
