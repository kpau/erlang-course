%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob03).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, element_at/2]).

test() -> [
  ?assertEqual(2, element_at(1, [2])),
  ?assertEqual(3, element_at(1, [3, 5])),
  ?assertEqual(4, element_at(4, [1, 2, 3, 4])),
  ?assertEqual(97, element_at(3, "dsad")),
  ?assertEqual(s, element_at(2, [d, s, a])),
  ?assertEqual("a", element_at(2, [1, "a", a]))
].

%% Problem 3
%% (*) Find the K'th element of a list. The first element in the list is number 1.

element_at(1, [X | _]) -> X;
element_at(K, [_ | T]) -> element_at(K - 1, T).