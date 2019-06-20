%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob02).
-author("knikolov").
-include_lib("eunit/include/eunit.hrl").

%% API
-export([test/0, prelast/1]).

test() ->
  assert:equal(2, prelast([2,5])),
  assert:equal(3, prelast([1,2,3,4])),
  assert:equal(97, prelast("dsad")),
  assert:equal(s, prelast([d,s,a])),
  assert:equal("a", prelast([1, "a", a])),

  ok.

%% Problem 2
%% (*) Find the last but one element of a list.
prelast([X|[_]]) -> X;
prelast([_|T]) -> prelast(T).