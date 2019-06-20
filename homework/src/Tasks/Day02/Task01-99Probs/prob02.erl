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
-export([test/0, prelast/1]).


test() -> [
  ?assertEqual(2, prelast([2,5])),
  ?assertEqual(3, prelast([1,2,3,4])),
  ?assertEqual(97, prelast("dsad")),
  ?assertEqual(s, prelast([d,s,a])),
  ?assertEqual("a", prelast([1, "a", a]))
].

%% Problem 2
%% (*) Find the last but one element of a list.
prelast([X|[_]]) -> X;
prelast([_|T]) -> prelast(T).