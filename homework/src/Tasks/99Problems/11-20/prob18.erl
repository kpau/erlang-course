%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob18).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, slice/3]).

test() -> [
  ?assertEqual([1], slice([1], 1, 1)),
  ?assertEqual([1], slice([1, 2], 1, 1)),
  ?assertEqual([2, 3, 4], slice([1, 2, 3, 4, 5], 2, 4)),
  ?assertEqual([4], slice([1, 2, 3, 4], 4, 4)),
  ?assertEqual("bc", slice("abcde", 2, 3)),
  ?assertEqual([a, s], slice([a, s, d], 1, 2))
].

%% Problem 18
%% (**) Extract a slice from a list.
%% Given two indices, i and k, the slice is the list containing the elements between the i'th and k'th element of the original list (both limits included). Start counting the elements with 1.

slice(Input, I, K) -> slice(Input, I, K, []).

slice(_, 1, 0, Result) -> lists:reverse(Result);
slice([H | T], 1, K, Result) ->
  slice(T, 1, K - 1, [H | Result]);
slice([_ | T], I, K, Result) ->
  slice(T, I - 1, K - 1, Result).