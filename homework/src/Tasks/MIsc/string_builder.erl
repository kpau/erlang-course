%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jun 2019 10:58
%%%-------------------------------------------------------------------
-module(string_builder).
-author("knikolov").
-include_lib("../../Test/assertion.hrl").

-define(SB_TAG, str_builder).
-define(EMPTY_SB, {?SB_TAG, []}).

%% API
-export([test/0, new/0, new/1, append/2, to_string/1]).

test() -> [
  %%  new()
  ?assertEqual({str_builder, []}, ?EMPTY_SB),
  ?assertEqual(?EMPTY_SB, new()),

  ?assertEqual(
    {?SB_TAG, ["test"]},
    new("test")),

  ?assertEqual(
    {?SB_TAG, ["test", "Asd", "123", "aaa"]},
    new(["aaa", 123, "Asd", "test"])),

  %%  append()
  ?assertEqual(
    {?SB_TAG, ["asd", "test"]},
    append("asd", {?SB_TAG, ["test"]})),

  ?assertEqual(
    {?SB_TAG, ["123", "asd", "test"]},
    append(123, {?SB_TAG, ["asd", "test"]})),

  ?assertEqual(
    {?SB_TAG, ["qwe", "123", "asd", "aaa", "test"]},
    append(["asd", 123, qwe], {?SB_TAG, ["aaa", "test"]})),

  %%  to_string()
  ?assertEqual(
    "",
    to_string(?EMPTY_SB)
  ),

  ?assertEqual(
    "test",
    to_string({?SB_TAG, ["test"]})),

  ?assertEqual(
    "testasd",
    to_string({?SB_TAG, ["asd", "test"]})),

  ?assertEqual(
    "testasd123",
    to_string({?SB_TAG, ["123", "asd", "test"]}))
].

new() -> ?EMPTY_SB.
new(Initial) -> append(Initial, ?EMPTY_SB).

append(NewValue = [ H | _], StringBuilder = {?SB_TAG, _}) when not is_integer(H)->
  lists:foldl(fun(Val, Res) -> append(Val, Res) end, StringBuilder, NewValue);
append(NewValue, {?SB_TAG, SbValue}) ->
  {?SB_TAG, [types:any_to_string(NewValue) | SbValue]}.

to_string(_StringBuilder = {?SB_TAG, SbValue}) -> lists:concat(lists:reverse(SbValue)).

