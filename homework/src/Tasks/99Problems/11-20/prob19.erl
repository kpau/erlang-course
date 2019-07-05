%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob19).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, rotate/2]).

test() -> [
  ?assertEqual([], rotate([], 0)),
  ?assertEqual([1], rotate([1], 1)),
  ?assertEqual([1, 2, 3], rotate([1, 2, 3], 0)),
  ?assertEqual([3, 4, 5, 1, 2], rotate([1, 2, 3, 4, 5], 2)),
  ?assertEqual([4, 5, 1, 2, 3], rotate([1, 2, 3, 4, 5], -2)),
  ?assertEqual("defghabc", rotate("abcdefgh", 3)),
  ?assertEqual("ghabcdef", rotate("abcdefgh", -2))
].

%% Problem 19
%% (**) Rotate a list N places to the left.
%% Hint: Use the predefined functions length and (++).

rotate(Input, N) -> rotate(Input, N, [], []).

rotate(Input, N, Start, End) when N < 0 ->
  rotate(Input, length(Input) + N, Start, End);
rotate([], _, Start, End) ->
  lists:reverse(Start) ++ lists:reverse(End);
rotate([H | T], 0, Start, End) ->
  rotate(T, 0, [H | Start], End);
rotate([H | T], N, Start, End) ->
  rotate(T, N - 1, Start, [H | End]).
