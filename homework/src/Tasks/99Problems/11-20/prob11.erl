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
-export([test/0, encodeModified/1]).


test() -> [
  ?assertEqual([], encodeModified([])),
  ?assertEqual([1], encodeModified([1])),
  ?assertEqual([{2, 2}], encodeModified([2, 2])),
  ?assertEqual([{5, 3}], encodeModified([3, 3, 3, 3, 3])),
  ?assertEqual([{3, 1}, {2, 2}], encodeModified([1, 1, 1, 2, 2])),
  ?assertEqual([1, {2, 2}, 3], encodeModified([1, 2, 2, 3])),
  ?assertEqual([{2, 1}, 2, 3, {3, 4}], encodeModified([1, 1, 2, 3, 4, 4, 4])),
  ?assertEqual([{4, 97}, 98, {2, 99}, {2, 97}, 100, {4, 101}], encodeModified("aaaabccaadeeee")),
  ?assertEqual([{4, a}, b, {2, c}, {2, a}, d, {4, e}], encodeModified([a, a, a, a, b, c, c, a, a, d, e, e, e, e])),
  ?assertEqual([{3, 1}, {2, "a"}, {4, a}], encodeModified([1, 1, 1, "a", "a", a, a, a, a]))
].

%% Problem 11
%% (*) Modified run-length encoding.
%% Modify the result of problem 10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as (N E) lists.

encodeModified(List) -> lists:reverse(encodeModified(prob09:pack(List), [])).

encodeModified([], Result) -> Result;
encodeModified([H = [HEl | _] | T], Result) ->
  Length = prob04:myLength(H),
  if
    (Length =:= 1) -> encodeModified(T, [HEl | Result]);
    true -> encodeModified(T, [{prob04:myLength(H), HEl} | Result])
  end.
