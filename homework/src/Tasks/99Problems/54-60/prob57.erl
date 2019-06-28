%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob57).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, construct/1]).


test() -> [
  ?assertEqual({[1, 2], 3, [5, 7]}, split([1, 2, 3, 5, 7])),
  ?assertEqual({[1, 2], 3, [5]}, split([1, 2, 3, 5])),

  ?assertEqual(tree:empty(), construct([])),

  ?assertEqual(
    {node, {3, 3},
      {node, {2, 2},
        {node, {1, 1}, tree:empty(), tree:empty()},
        tree:empty()},
      {node, {7, 7},
        {node, {5, 5}, tree:empty(), tree:empty()},
        tree:empty()}
    },
    construct([3, 2, 5, 7, 1])),

  ?assertEqual(
    {node, {5, 5},
      {node, {3, 3},
        {node, {2, 2},
          {node, {1, 1}, tree:empty(), tree:empty()},
          tree:empty()},
        {node, {4, 4}, tree:empty(), tree:empty()}},
      {node, {7, 7},
        {node, {6, 6}, tree:empty(), tree:empty()},
        {node, {8, 8}, tree:empty(), tree:empty()}}
    },
    construct([3, 2, 6, 5, 8, 7, 4, 1]))
].

%% Problem 57
%% (**) Binary search trees (dictionaries)
%% Use the predicate add/3, developed in chapter 4 of the course, to write a predicate to construct a binary search tree from a list of integer numbers.

construct(List) -> construct(lists:sort(List), tree:empty()).

construct([], Tree) -> Tree;
construct([Val], Tree) -> tree:insert(Val, Tree);
construct(List, Tree) ->
  {FirstHalf, Middle, SecondHalf} = split(List),
  {node, Val, LeftNode, RightNode} = tree:insert(Middle, Tree),
  LeftTree = construct(FirstHalf, LeftNode),
  RightTree = construct(SecondHalf, RightNode),
  {node, Val, LeftTree, RightTree}.

split(List) -> split(List, List, []).

split([], [Mid | SecondHalf], FirstHalf) -> {lists:reverse(FirstHalf), Mid, SecondHalf};
split([_], [Mid | SecondHalf], FirstHalf) -> {lists:reverse(FirstHalf), Mid, SecondHalf};
split([_, _ | Counter], List = [H | T], FirstHalf) ->
  split(Counter, T, [H | FirstHalf]).



