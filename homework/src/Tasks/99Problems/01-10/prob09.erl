%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob09).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, pack/1]).


test() -> [
  ?assertEqual([], pack([])),
  ?assertEqual([[1]], pack([1])),
  ?assertEqual([[2, 2]], pack([2, 2])),
  ?assertEqual([[3, 3, 3, 3, 3]], pack([3, 3, 3, 3, 3])),
  ?assertEqual([[1, 1, 1], [2, 2]], pack([1, 1, 1, 2, 2])),
  ?assertEqual([[1], [2, 2], [3]], pack([1, 2, 2, 3])),
  ?assertEqual([[1, 1], [2], [3], [4, 4, 4]], pack([1, 1, 2, 3, 4, 4, 4])),
  ?assertEqual(["aaaa", "b", "cc", "aa", "d", "eeee"], pack("aaaabccaadeeee")),
  ?assertEqual([[a, a, a, a], [b], [c, c], [a, a], [d], [e, e, e, e]], pack([a, a, a, a, b, c, c, a, a, d, e, e, e, e])),
  ?assertEqual([[1, 1, 1], ["a", "a"], [a, a, a, a]], pack([1, 1, 1, "a", "a", a, a, a, a]))
].

%% Problem 9
%% (**) Pack consecutive duplicates of list elements into sublists. If a list contains repeated elements they should be placed in separate sublists.

pack(List) -> lists:reverse(pack(List, [])).

pack([], Result) -> Result;
pack([H | TIn], [[H | TEl] | TRes]) -> pack(TIn, [[H, H | TEl] | TRes]);
pack([H | TIn], Result) -> pack(TIn, [[H] | Result]).
