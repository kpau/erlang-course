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
-export([test/0, last/1]).

test() -> [
  ?assertEqual(3, last([3])),
  ?assertEqual(5, last([2,5])),
  ?assertEqual(4, last([1,2,3,4])),
  ?assertEqual(97, last("dsa")),
  ?assertEqual(a, last([d,s,a])),
  ?assertEqual(a, last([1, "a", a]))
].

%% Problem 1
%% (*) Find the last element of a list.
last([X]) -> X;
last([_|T]) -> last(T).