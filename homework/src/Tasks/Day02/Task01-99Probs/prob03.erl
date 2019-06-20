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
-export([test/0, get_kth/2]).


test() -> [
  ?assertEqual(2, get_kth(1, [2])),
  ?assertEqual(3, get_kth(1, [3,5])),
  ?assertEqual(4, get_kth(4, [1,2,3,4])),
  ?assertEqual(97, get_kth(3, "dsad")),
  ?assertEqual(s, get_kth(2, [d,s,a])),
  ?assertEqual("a", get_kth(2, [1, "a", a]))
].

%% Problem 3
%% (*) Find the K'th element of a list. The first element in the list is number 1.
get_kth(1, [X|_]) -> X;
get_kth(K, [_|T]) -> get_kth(K-1, T).