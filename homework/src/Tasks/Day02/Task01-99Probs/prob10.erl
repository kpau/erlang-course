%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob10).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, encode/1]).


test() -> [
  ?assertEqual([], encode([])),
  ?assertEqual([{1, 1}], encode([1])),
  ?assertEqual([{2, 2}], encode([2, 2])),
  ?assertEqual([{5, 3}], encode([3, 3, 3, 3, 3])),
  ?assertEqual([{3, 1}, {2, 2}], encode([1, 1, 1, 2, 2])),
  ?assertEqual([{1, 1}, {2, 2}, {1, 3}], encode([1, 2, 2, 3])),
  ?assertEqual([{2, 1}, {1, 2}, {1, 3}, {3, 4}], encode([1, 1, 2, 3, 4, 4, 4])),
  ?assertEqual([{4, 97}, {1, 98}, {2, 99}, {2, 97}, {1, 100}, {4, 101}], encode("aaaabccaadeeee")),
  ?assertEqual([{4, a}, {1, b}, {2, c}, {2, a}, {1, d}, {4, e}], encode([a, a, a, a, b, c, c, a, a, d, e, e, e, e])),
  ?assertEqual([{3, 1}, {2, "a"}, {4, a}], encode([1, 1, 1, "a", "a", a, a, a, a]))
].

%% Problem 8
%% (*) Run-length encoding of a list. Use the result of problem P09 to implement the so-called run-length encoding data compression method. Consecutive duplicates of elements are encoded as lists (N E) where N is the number of duplicates of the element E.

encode(List) -> lists:reverse(encode(prob09:pack(List), [])).

encode([], Result) -> Result;
encode([H = [HEl | _] | T], Result) -> encode(T, [{prob04:myLength(H), HEl} | Result]).
