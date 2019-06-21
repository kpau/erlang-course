%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob07).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, my_flatten/1]).


test() -> [
  ?assertEqual([], my_flatten([])),
  ?assertEqual([2], my_flatten(2)),
  ?assertEqual([2], my_flatten([2])),
  ?assertEqual([1, 2, 3, 4], my_flatten([1, 2, 3, 4])),
  ?assertEqual("dsad", my_flatten("dsad")),
  ?assertEqual([d, s, a], my_flatten([d, s, a])),
  ?assertEqual([1, 97, a], my_flatten([1, "a", a])),

  ?assertEqual([], my_flatten([[], [[]]])),
  ?assertEqual([1, 2, 3, 4, 5, 6], my_flatten([[1], 2, [[3], 4], [5, 6]]))
].

%% Problem 7
%% (**) Flatten a nested list structure.
%% Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements (recursively).

my_flatten(List) -> lists:reverse(my_flatten(List, [])).

my_flatten([], Result) -> Result;
my_flatten(E, Result) when not is_list(E) ->
  [E | Result];
my_flatten([H | T], Result) when is_list(H) ->
  my_flatten(T, my_flatten(H, Result));
my_flatten([H | T], Result) ->
  my_flatten(T, [H | Result]).

