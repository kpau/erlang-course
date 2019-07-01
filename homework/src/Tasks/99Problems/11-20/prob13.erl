%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob13).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, encode_direct/1]).

test() -> [
  ?assertEqual([], encode_direct([])),
  ?assertEqual([1], encode_direct([1])),
  ?assertEqual([{2, 2}], encode_direct([2, 2])),
  ?assertEqual([{5, 3}], encode_direct([3, 3, 3, 3, 3])),
  ?assertEqual([{3, 1}, {2, 2}], encode_direct([1, 1, 1, 2, 2])),
  ?assertEqual([1, {2, 2}, 3], encode_direct([1, 2, 2, 3])),
  ?assertEqual([{2, 1}, 2, 3, {3, 4}], encode_direct([1, 1, 2, 3, 4, 4, 4])),
  ?assertEqual([{4, 97}, 98, {2, 99}, {2, 97}, 100, {4, 101}], encode_direct("aaaabccaadeeee")),
  ?assertEqual([{4, a}, b, {2, c}, {2, a}, d, {4, e}], encode_direct([a, a, a, a, b, c, c, a, a, d, e, e, e, e])),
  ?assertEqual([{3, 1}, {2, "a"}, {4, a}], encode_direct([1, 1, 1, "a", "a", a, a, a, a]))
].

%% Problem 13
%% (**) Run-length encoding of a list (direct solution).
%% Implement the so-called run-length encoding data compression method directly. I.e. don't explicitly create the sublists containing the duplicates, as in problem 9, but only count them. As in problem P11, simplify the result list by replacing the singleton lists (1 X) by X.

encode_direct(Input) -> lists:reverse(encode_direct(Input, [])).

encode_direct([], Result) -> Result;
encode_direct([H | TIn], [H | TOut]) ->
  encode_direct(TIn, [{2, H} | TOut]);
encode_direct([H | TIn], [{Count, H} | TOut]) ->
  encode_direct(TIn, [{Count + 1, H} | TOut]);
encode_direct([HIn | TIn], Output) ->
  encode_direct(TIn, [HIn | Output]).

