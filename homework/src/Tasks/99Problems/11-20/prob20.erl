%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob20).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, remove_at/2]).

test() -> [
  ?assertEqual([], remove_at(1, [1])),
  ?assertEqual([1, 3], remove_at(2, [1, 2, 3])),
  ?assertEqual([1,2,3,4], remove_at(5, [1, 2, 3, 4, 5])),
  ?assertEqual("acd", remove_at(2, "abcd"))
].

%% Problem 20
%% (*) Remove the K'th element from a list.

remove_at(Index, List) -> remove_at(Index, List, []).

remove_at(1, [_ | T], Result) -> lists:reverse(Result) ++ T;
remove_at(Index, [H | T], Result) ->
  remove_at(Index - 1, T, [H | Result]).
