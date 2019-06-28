%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jun 2019 10:18
%%%-------------------------------------------------------------------
-module(heathrow).
-author("knikolov").
-include_lib("../../Test/assertion.hrl").

-define(EMPTY_PATH, {0, []}).

%% API
-export([test/0, path/1]).

test() -> [
  ?assertEqual({10, [a]}, path([{10, 15, 0}])),

  ?assertEqual({14, [b, x, a]}, path([{5, 1, 3}, {10, 15, 0}])),

  ?assertEqual({75, [b, x, a, x, b, b]}, path([{50, 10, 30}, {5, 90, 20}, {40, 2, 25}, {10, 8, 0}]))
].

path(Input) ->
  {FullPathA, FullPathB} = paths(Input),
  {Len, Path} = min(FullPathA, FullPathB),
  {Len, format_path(Path)}.

%% Get shortest paths to the last A and B points
paths(Input) ->
  lists:foldl(fun next/2, {?EMPTY_PATH, ?EMPTY_PATH}, Input).

%% Get shortest paths from current A and B points, to the next ones
next(Roads, Paths) ->
  {next_a(Roads, Paths), next_b(Roads, Paths)}.

%% Shortest path to the next A point
next_a({A, B, X}, {{LenA, PathA}, {LenB, PathB}}) ->
  FromA = {LenA + A, [a | PathA]},
  FromB = {LenB + B + X, [x, b | PathB]},
  min(FromA, FromB).

%% Shortest path to the next B point
next_b({A, B, X}, {{LenA, PathA}, {LenB, PathB}}) ->
  FromA = {LenA + A + X, [x, a | PathA]},
  FromB = {LenB + B, [b | PathB]},
  min(FromA, FromB).

%% Last X is always zero, so remove it
format_path([x | Path]) -> format_path(Path);
format_path(Path) -> lists:reverse(Path).

