%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:46
%%%-------------------------------------------------------------------
-module(prob55).
-author("knikolov").
-include_lib("../../../Test/assertion.hrl").

%% API
-export([test/0, cbal_tree/1]).


test() -> [
  %% shit!
].

%% Problem 55
%% (**) Construct completely balanced binary trees
%% In a completely balanced binary tree, the following property holds for every node: The number of nodes in its left subtree and the number of nodes in its right subtree are almost equal, which means their difference is not greater than one.
%% Write a function cbal-tree to construct completely balanced binary trees for a given number of nodes. The predicate should generate all solutions via backtracking. Put the letter 'x' as information into all nodes of the tree.


cbal_tree(1) ->
  Nodes = list(1),
  [construct(Nodes)];
cbal_tree(Size) when Size rem 2 =:= 0 ->
  Nodes = list(Size),
  [construct(Nodes)];
cbal_tree(Size) ->
  Nodes = list(Size - 1),
  construct(Nodes).

list(Size) -> list(Size, []).

list(0, Result) -> Result;
list(Size, Result) -> list(Size-1, [x, Result]).

construct(List) -> construct(List, tree:empty()).

construct([], Tree) -> Tree;
construct([H | T], Tree) ->
  construct(T, tree:insert(H, Tree)).

