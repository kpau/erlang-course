%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob04).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, myLength/1]).

test() -> [
  ?assertEqual(1, myLength([2])),
  ?assertEqual(4, myLength([1, 2, 3, 4])),
  ?assertEqual(4, myLength("dsad")),
  ?assertEqual(3, myLength([d, s, a])),
  ?assertEqual(3, myLength([1, "a", a]))
].

%% Problem 4
%% (*) Find the number of elements of a list.

myLength(List) -> myLength(List, 0).

myLength([], Length) -> Length;
myLength([_ | T], Length) -> myLength(T, Length + 1).
