%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob08).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, compress/1]).

test() -> [
  ?assertEqual([], compress([])),
  ?assertEqual([1], compress([1])),
  ?assertEqual([2], compress([2, 2])),
  ?assertEqual([3], compress([3, 3, 3, 3, 3])),
  ?assertEqual([1, 2], compress([1, 1, 1, 2, 2])),
  ?assertEqual([1, 2, 3], compress([1, 2, 2, 3])),
  ?assertEqual([1, 2, 3, 4], compress([1, 1, 2, 3, 4, 4, 4])),
  ?assertEqual("abcade", compress("aaaabccaadeeee")),
  ?assertEqual([a, b, c, a, d, e], compress([a, a, a, a, b, c, c, a, a, d, e, e, e, e])),
  ?assertEqual([1, "a", a], compress([1, 1, 1, "a", "a", a, a, a, a]))
].

%% Problem 8
%% (**) Eliminate consecutive duplicates of list elements.
%% If a list contains repeated elements they should be replaced with a single copy of the element. The order of the elements should not be changed.

compress(List) -> lists:reverse(compress(List, [])).

compress([], Result) -> Result;
compress([H | TIn], Result = [H | _]) -> compress(TIn, Result);
compress([H | TIn], Result) -> compress(TIn, [H | Result]).
