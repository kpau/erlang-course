%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob12).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, decode_modified/1]).

test() -> [
  ?assertEqual("", decode_modified("")),
  ?assertEqual([1], decode_modified([1])),
  ?assertEqual([2, 2], decode_modified([{2, 2}])),
  ?assertEqual([3, 3, 3, 3, 3], decode_modified([{5, 3}])),
  ?assertEqual([1, 1, 1, 2, 2], decode_modified([{3, 1}, {2, 2}])),
  ?assertEqual([1, 2, 2, 3], decode_modified([1, {2, 2}, 3])),
  ?assertEqual([1, 1, 2, 3, 4, 4, 4], decode_modified([{2, 1}, 2, 3, {3, 4}])),
  ?assertEqual("aaaabccaadeeee", decode_modified([{4, 97}, 98, {2, 99}, {2, 97}, 100, {4, 101}])),
  ?assertEqual([a, a, a, a, b, c, c, a, a, d, e, e, e, e], decode_modified([{4, a}, b, {2, c}, {2, a}, d, {4, e}])),
  ?assertEqual([1, 1, 1, "a", "a", a, a, a, a], decode_modified([{3, 1}, {2, "a"}, {4, a}]))
].

%% Problem 12
%% (**) Decode a run-length encoded list.
%% Given a run-length code list generated as specified in problem 11. Construct its uncompressed version.

decode_modified(Encode) -> lists:reverse(decode_modified(Encode, [])).

decode_modified([], Result) -> Result;
decode_modified([{Count, Val} | T], Result) ->
  Decoded = repeat_val(Count, Val),
  decode_modified(T, Decoded ++ Result);
decode_modified([H | T], Result) ->
  decode_modified(T, concat(H, Result)).

repeat_val(N, Val) -> repeat_val(N, Val, []).

repeat_val(0, _, Result) -> Result;
repeat_val(N, Val, Result) ->
  repeat_val(N - 1, Val, concat(Val, Result)).

concat(A, B) -> [A | B].