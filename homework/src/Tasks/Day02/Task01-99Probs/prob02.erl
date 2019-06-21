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
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, myButLast/1]).

test() -> [
  ?assertEqual(2, myButLast([2, 5])),
  ?assertEqual(3, myButLast([1, 2, 3, 4])),
  ?assertEqual(97, myButLast("dsad")),
  ?assertEqual(s, myButLast([d, s, a])),
  ?assertEqual("a", myButLast([1, "a", a]))
].

%% Problem 2
%% (*) Find the last but one element of a list.

myButLast([X | [_]]) -> X;
myButLast([_ | T]) -> myButLast(T).