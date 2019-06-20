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
-include_lib("eunit/include/eunit.hrl").

%% API
-export([test/0, last/1]).

test() ->
  ?assertEqual(1, 2),

  assert:equal(3, last([3])),
  assert:equal(5, last([2,5])),
  assert:equal(4, last([1,2,3,4])),
  assert:equal(97, last("dsa")),
  assert:equal(a, last([d,s,a])),
  assert:equal(a, last([1, "a", a])),

  ok.

%% Problem 1
%% (*) Find the last element of a list.
last([X]) -> X;
last([_|T]) -> last(T).