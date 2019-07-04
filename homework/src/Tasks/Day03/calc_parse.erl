%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jun 2019 18:02
%%%-------------------------------------------------------------------
-module(calc_parse).
-author("knikolov").

%% API
-export([test/0, parse/1]).

-include_lib("../../Test/assertion.hrl").
-include_lib("./calc.hrl").


test() -> [
  ?assertEqual(5, parse([5])),
  ?assertEqual(5, parse([2, 3, ?PLU])),
  ?assertEqual(10, parse([2, 3, ?MUL, 4, ?PLU])),
  ?assertEqual(50, parse([10, 2, 3, ?PLU, ?MUL])),
  ?assertEqual(23, parse([10, 2, ?MUL, 3, ?PLU])),
  ?assertEqual(2.0, parse([8, 2, ?MNS, 3, ?DIV])),
  ?assertEqual(32.0, parse([30, 64, 8, ?MUL, 5, 3, ?MNS, 2, 3, ?POW, ?POW, ?DIV, ?PLU])),
  ?assertEqual(9, parse([6, 9, ?MAX(2)])),
  ?assertEqual(10, parse([6, 9, 4, ?MAX(3), 2, 3, 1, 5, ?MIN(4), ?PLU])),
  ?assertEqual(0.5, parse([2, ?PI, ?MUL, 4, ?DIV, ?SIN, 2, ?PI, ?MUL, 3, ?DIV, ?COS, ?PLU]))
].

parse(Input) -> parse(Input, []).

parse([], [Result]) ->
  Result;
parse([HInput | TInput], Stack) when is_integer(HInput); is_float(HInput) ->
  parse(TInput, [HInput | Stack]);
parse([#op{func = Operation, n = Count} | TInput], Stack) ->
  {Numbers, NewStack} = pop(Count, Stack),
  OperationResult = Operation(Numbers),
  parse(TInput, [OperationResult | NewStack]).

pop(N, Stack) -> pop(N, 0, [], Stack).

pop(any, _, Popped, []) ->
  {Popped, []};
pop(any, _, Popped, Stack = [#op{} | T]) ->
  {Popped, Stack};
pop(any, Count, Popped, [H | T]) ->
  pop(any, Count + 1, [H | Popped], T);
pop(N, N, Popped, Stack) ->
  {Popped, Stack};
pop(N, Count, Popped, [H | T]) ->
  pop(N, Count + 1, [H | Popped], T).

