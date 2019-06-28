%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jun 2019 10:02
%%%-------------------------------------------------------------------
-module(tree).
-author("knikolov").
-include_lib("../../Test/assertion.hrl").

-define(NODE_KEY, node).
-define(EMPTY_TREE, {?NODE_KEY, nil}).

%% API
-export([test/0, empty/0, insert/2, lookup/2, to_string/1, is_binary_tree/1]).

%% { ?NODE_KEY, { Key, Value }, LeftNode, RightNode }

test() -> [
  ?assertEqual({node, nil}, ?EMPTY_TREE),
  ?assertEqual(?EMPTY_TREE, empty()),

  ?assertEqual(
    {node, {1, 1}, ?EMPTY_TREE, ?EMPTY_TREE},
    insert(
      1, ?EMPTY_TREE
    )),

  ?assertEqual(
    {node, {1, root}, ?EMPTY_TREE, ?EMPTY_TREE},
    insert(
      {1, root}, ?EMPTY_TREE
    )),

  ?assertEqual(
    {node, {5, root},
      {node, {3, 3}, ?EMPTY_TREE, ?EMPTY_TREE},
      ?EMPTY_TREE},
    insert(
      3,
      {node, {5, root}, ?EMPTY_TREE, ?EMPTY_TREE}
    )),

  ?assertEqual(
    {node, {5, root},
      {node, {3, valA}, ?EMPTY_TREE, ?EMPTY_TREE},
      ?EMPTY_TREE},
    insert(
      {3, valA},
      {node, {5, root}, ?EMPTY_TREE, ?EMPTY_TREE}
    )),

  ?assertEqual(
    {node, {5, root},
      {node, {3, valA}, ?EMPTY_TREE, ?EMPTY_TREE},
      {node, {7, valB}, ?EMPTY_TREE, ?EMPTY_TREE}
    },
    insert(
      {7, valB},
      {node, {5, root},
        {node, {3, valA}, ?EMPTY_TREE, ?EMPTY_TREE},
        ?EMPTY_TREE}
    )),

  ?assertEqual(
    {node, {5, rootNew},
      {node, {3, valA}, ?EMPTY_TREE, ?EMPTY_TREE},
      {node, {7, valB}, ?EMPTY_TREE, ?EMPTY_TREE}
    },
    insert(
      {5, rootNew},
      {node, {5, root},
        {node, {3, valA}, ?EMPTY_TREE, ?EMPTY_TREE},
        {node, {7, valB}, ?EMPTY_TREE, ?EMPTY_TREE}}
    )),

  ?assertEqual(
    {node, {5, root},
      {node, {3, valA},
        ?EMPTY_TREE,
        {node, {4, valC}, ?EMPTY_TREE, ?EMPTY_TREE}},
      {node, {7, valB}, ?EMPTY_TREE, ?EMPTY_TREE}
    },
    insert(
      {4, valC},
      {node, {5, root},
        {node, {3, valA}, ?EMPTY_TREE, ?EMPTY_TREE},
        {node, {7, valB}, ?EMPTY_TREE, ?EMPTY_TREE}}
    )),

  ?assertEqual(
    {node, {5, root},
      {node, {3, valA},
        ?EMPTY_TREE,
        {node, {4, valC}, ?EMPTY_TREE, ?EMPTY_TREE}},
      {node, {7, valB},
        {node, {6, valD}, ?EMPTY_TREE, ?EMPTY_TREE},
        ?EMPTY_TREE}
    },
    insert(
      {6, valD},
      {node, {5, root},
        {node, {3, valA},
          ?EMPTY_TREE,
          {node, {4, valC}, ?EMPTY_TREE, ?EMPTY_TREE}},
        {node, {7, valB}, ?EMPTY_TREE, ?EMPTY_TREE}
      }
    )),

  %%  lookup()
  ?assertEqual(undefined,
    lookup(2,
      {node, {5, root},
        {node, {3, valA},
          ?EMPTY_TREE,
          {node, {4, valC}, ?EMPTY_TREE, ?EMPTY_TREE}},
        {node, {7, valB},
          {node, {6, valD}, ?EMPTY_TREE, ?EMPTY_TREE},
          ?EMPTY_TREE}
      })),

  ?assertEqual({found, valC},
    lookup(4,
      {node, {5, root},
        {node, {3, valA},
          ?EMPTY_TREE,
          {node, {4, valC}, ?EMPTY_TREE, ?EMPTY_TREE}},
        {node, {7, valB},
          {node, {6, valD}, ?EMPTY_TREE, ?EMPTY_TREE},
          ?EMPTY_TREE}
      })),

  ?assertEqual(true, is_binary_tree(?EMPTY_TREE)),
  ?assertEqual(true, is_binary_tree(
    {node, {5, root},
      {node, {3, valA},
        ?EMPTY_TREE,
        {node, {4, valC}, ?EMPTY_TREE, ?EMPTY_TREE}},
      {node, {7, valB},
        {node, {6, valD}, ?EMPTY_TREE, ?EMPTY_TREE},
        ?EMPTY_TREE}
    })),
  ?assertEqual(false, is_binary_tree(something)),
  ?assertEqual(false, is_binary_tree(1)),
  ?assertEqual(false, is_binary_tree({?NODE_KEY})),
  ?assertEqual(false, is_binary_tree({?NODE_KEY, {test, test}})),
  ?assertEqual(false, is_binary_tree({?NODE_KEY, {test, test}, ?EMPTY_TREE})),
  ?assertEqual(false, is_binary_tree({?NODE_KEY, ?EMPTY_TREE, ?EMPTY_TREE}))
  ].

empty() -> ?EMPTY_TREE.

insert(New, Tree) when is_integer(New) ->
  insert({New, New}, Tree);
insert(New, ?EMPTY_TREE) ->
  {?NODE_KEY, New, ?EMPTY_TREE, ?EMPTY_TREE};
insert(New = {NewKey, _NewVal}, {?NODE_KEY, Current = {Key, _}, LeftNode, RightNode}) when NewKey < Key ->
  {?NODE_KEY, Current, insert(New, LeftNode), RightNode};
insert(New = {NewKey, _NewVal}, {?NODE_KEY, Current = {Key, _}, LeftNode, RightNode}) when NewKey > Key ->
  {?NODE_KEY, Current, LeftNode, insert(New, RightNode)};
insert(New = {_NewKey, _NewVal}, {?NODE_KEY, Current = {Key, _}, LeftNode, RightNode}) ->
  {?NODE_KEY, New, LeftNode, RightNode}.

lookup(Key, ?EMPTY_TREE) -> undefined;
lookup(Key, {node, {Key, Val}, _, _}) -> {found, Val};
lookup(Key, {node, {NodeKey, _}, LeftNode, _RightNode}) when Key < NodeKey ->
  lookup(Key, LeftNode);
lookup(Key, {node, {NodeKey, _}, _LeftNode, RightNode}) when Key > NodeKey ->
  lookup(Key, RightNode).

to_string(Tree) -> to_string(Tree, 0).
to_string(?EMPTY_TREE, _) -> "";
to_string({?NODE_KEY, {Key, Value}, LeftNode, RightNode}, Depth) ->
  Sb_indent = string_builder:new(indentation(Depth)),
  io:format("ind: ~p~n", [Sb_indent]),
  Sb_node = string_builder:append(["(", Key, ", ", Value, ")~n"], Sb_indent),
  io:format("nod: ~p~n", [Sb_node]),
  Sb_result = string_builder:append([to_string(LeftNode, Depth + 1), to_string(RightNode, Depth + 1)], Sb_node),
  io:format("res: ~p~n", [Sb_result]),
  string_builder:to_string(Sb_result).

indentation(Depth) -> indentation(Depth, string_builder:new()).
indentation(0, Result) -> string_builder:to_string(Result);
indentation(1, Result) ->
  indentation(0, string_builder:append("├──", Result));
indentation(Depth, Result) ->
  indentation(Depth - 1, string_builder:append("│  ", Result)).

is_binary_tree(?EMPTY_TREE) ->
  true;
is_binary_tree({?NODE_KEY, {_, _}, LeftNode, RightNode}) ->
  is_binary_tree(LeftNode) andalso is_binary_tree(RightNode);
is_binary_tree(Something) ->
  false.
