%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob05).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, myReverse/1]).


test() -> [
  ?assertEqual([], myReverse([])),
  ?assertEqual([2], myReverse([2])),
  ?assertEqual([4, 3, 2, 1], myReverse([1, 2, 3, 4])),
  ?assertEqual("dasd", myReverse("dsad")),
  ?assertEqual([a, s, d], myReverse([d, s, a])),
  ?assertEqual([a, "a", 1], myReverse([1, "a", a]))
].

%% Problem 5
%% (*) Reverse a list.

myReverse(List) -> myReverse(List, []).

myReverse([], ReversedList) -> ReversedList;
myReverse([H | T], ReversedList) -> myReverse(T, [H | ReversedList]).
