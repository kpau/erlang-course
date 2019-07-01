%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob14).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, dupli/1]).

test() -> [
  ?assertEqual([], dupli([])),
  ?assertEqual([1, 1], dupli([1])),
  ?assertEqual([1, 1, 2, 2, 3, 3], dupli([1, 2, 3])),
  ?assertEqual("aassdd", dupli("asd")),
  ?assertEqual([a, a, s, s, d, d], dupli([a, s, d]))
  ].

%% Problem 14
%% (*) Duplicate the elements of a list.

dupli(Input) -> lists:reverse(dupli(Input, [])).

dupli([], Result) -> Result;
dupli([H | T], Result) ->
  dupli(T, [H, H | Result]).
