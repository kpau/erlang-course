%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob11).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, encode_modified/1]).

test() -> [
  ?assertEqual([], encode_modified([])),
  ?assertEqual([1], encode_modified([1])),
  ?assertEqual([{2, 2}], encode_modified([2, 2])),
  ?assertEqual([{5, 3}], encode_modified([3, 3, 3, 3, 3])),
  ?assertEqual([{3, 1}, {2, 2}], encode_modified([1, 1, 1, 2, 2])),
  ?assertEqual([1, {2, 2}, 3], encode_modified([1, 2, 2, 3])),
  ?assertEqual([{2, 1}, 2, 3, {3, 4}], encode_modified([1, 1, 2, 3, 4, 4, 4])),
  ?assertEqual([{4, 97}, 98, {2, 99}, {2, 97}, 100, {4, 101}], encode_modified("aaaabccaadeeee")),
  ?assertEqual([{4, a}, b, {2, c}, {2, a}, d, {4, e}], encode_modified([a, a, a, a, b, c, c, a, a, d, e, e, e, e])),
  ?assertEqual([{3, 1}, {2, "a"}, {4, a}], encode_modified([1, 1, 1, "a", "a", a, a, a, a]))
].

%% Problem 11
%% (*) Modified run-length encoding.
%% Modify the result of problem 10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as (N E) lists.

encode_modified(List) -> lists:reverse(encode_modified(prob09:pack(List), [])).

encode_modified([], Result) -> Result;
encode_modified([[HEl] | T], Result) ->
  encode_modified(T, [HEl | Result]);
encode_modified([H = [HEl | _] | T], Result) ->
  encode_modified(T, [{prob04:myLength(H), HEl} | Result]).
