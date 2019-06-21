%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob01).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, myLast/1]).

test() -> [
  ?assertEqual(3, myLast([3])),
  ?assertEqual(5, myLast([2, 5])),
  ?assertEqual(4, myLast([1, 2, 3, 4])),
  ?assertEqual(97, myLast("dsa")),
  ?assertEqual(a, myLast([d, s, a])),
  ?assertEqual(a, myLast([1, "a", a]))
].

%% Problem 1
%% (*) Find the last element of a list.

myLast([X]) -> X;
myLast([_ | T]) -> myLast(T).