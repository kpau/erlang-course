%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jun 2019 18:02
%%%-------------------------------------------------------------------
-module(calc).
-author("knikolov").
-include_lib("../../Test/assertion.hrl").

%% Tokens
-define(UNDEF, undefined).
-define(NUM, number).
-define(OP, operator).

%% ASCII codes
-define(ZERO_CODE, 48).
-define(NINE_CODE, 57).
-define(SPACE_CODE, 32).

-define(POW_CODE, 94).
-define(MUL_CODE, 42).
-define(DIV_CODE, 47).
-define(PLU_CODE, 43).
-define(MIN_CODE, 45).
-define(OPB_CODE, 40).
-define(CLB_CODE, 41).

%% Operators
-define(POW, operator(?POW_CODE)).
-define(MUL, operator(?MUL_CODE)).
-define(DIV, operator(?DIV_CODE)).
-define(PLU, operator(?PLU_CODE)).
-define(MIN, operator(?MIN_CODE)).

%% API
-export([test/0, calculate/1, read/1, parse/1]).

test() -> [
  ?assertEqual([], read("")),
  ?assertEqual([5], read("5")),
  ?assertEqual([2, 3, ?PLU], read("2+3")),
  ?assertEqual([1, 2, ?MUL, 3, ?PLU], read("1*2+3")),
  ?assertEqual([1, 2, 3, ?PLU, ?MUL], read("1*(2+3)")),
  ?assertEqual([1, 2, ?MUL, 3, ?PLU], read("(1*2)+3")),
  ?assertEqual([1, 2, ?MIN, 3, ?DIV], read("(1-2)/3")),
  ?assertEqual([3, 4, 2, ?MUL, 1, 5, ?MIN, 2, 3, ?POW, ?POW, ?DIV, ?PLU], read("3+4*2/(1-5)^2^3")),
  ?assertEqual([3, 4, 2, ?MUL, 1, 5, ?MIN, 2, 3, ?POW, ?POW, ?DIV, ?PLU], read("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3")),
  ?assertEqual([315, 24, 122, ?MUL, 108, 65, ?MIN, 12, 30, ?POW, ?POW, ?DIV, ?PLU], read("315 + 24 * 122 / ( 108 - 65 ) ^ 12 ^ 30")),

  ?assertEqual(5, parse([5])),
  ?assertEqual(5, parse([2, 3, ?PLU])),
  ?assertEqual(10, parse([2, 3, ?MUL, 4, ?PLU])),
  ?assertEqual(50, parse([10, 2, 3, ?PLU, ?MUL])),
  ?assertEqual(23, parse([10, 2, ?MUL, 3, ?PLU])),
  ?assertEqual(2.0, parse([8, 2, ?MIN, 3, ?DIV])),
  ?assertEqual(32.0, parse([30, 64, 8, ?MUL, 5, 3, ?MIN, 2, 3, ?POW, ?POW, ?DIV, ?PLU])),

  ?assertEqual(5, calculate("5")),
  ?assertEqual(5, calculate("2+3")),
  ?assertEqual(32.0, calculate("30 + 64 * 8 / (5-3) ^2 ^3"))
].

calculate(Input) ->
  Rpn = read(Input),
  parse(Rpn).

%% Read input and parse from infix notation to Reverse Polish notation - Shunting-yard algorithm
read(Input) -> lists:reverse(read(Input, ?UNDEF, [], [])).

%% Remove whitespace
read([?SPACE_CODE | TInput], Token, Output, OperatorStack) ->
  read(TInput, Token, Output, OperatorStack);

%% Token: None
read([], ?UNDEF, Output, []) ->
  Output;
read([], ?UNDEF, Output, [H | OperatorStack]) ->
  read([], ?UNDEF, [H | Output], OperatorStack);
read([HInput | TInput], ?UNDEF, Output, OperatorStack) when HInput >= ?ZERO_CODE, HInput =< ?NINE_CODE ->
  read(TInput, {?NUM, [HInput]}, Output, OperatorStack);
read([HInput | TInput], ?UNDEF, Output, OperatorStack) ->
  Operator = operator(HInput),
  read(TInput, {?OP, Operator}, Output, OperatorStack);

%% Token: Number
read([HInput | TInput], {?NUM, TokenValue}, Output, OperatorStack) when HInput >= ?ZERO_CODE, HInput =< ?NINE_CODE ->
  read(TInput, {?NUM, [HInput | TokenValue]}, Output, OperatorStack);
read([], {?NUM, TokenValue}, Output, OperatorStack) ->
  TokenNumber = list_to_integer(lists:reverse(TokenValue)),
  read([], ?UNDEF, [TokenNumber | Output], OperatorStack);
read([HInput | TInput], {?NUM, TokenValue}, Output, OperatorStack) ->
  TokenNumber = list_to_integer(lists:reverse(TokenValue)),
  Operator = operator(HInput),
  read(TInput, {?OP, Operator}, [TokenNumber | Output], OperatorStack);

%% Token: Operator
read(Input, {?OP, TokenValue}, Output, []) ->
  read(Input, ?UNDEF, Output, [TokenValue]);
read(Input, {?OP, TokenValue = {open_brackets, _, _, _}}, Output, OperatorStack) ->
  read(Input, ?UNDEF, Output, [TokenValue | OperatorStack]);
read(Input, {?OP, _TokenValue = {close_brackets, _, _, _}}, Output, [{open_brackets, _, _, _} | TOper]) ->
  read(Input, ?UNDEF, Output, TOper);
read(Input, Token = {?OP, _TokenValue = {close_brackets, _, _, _}}, Output, [HOper | TOper]) ->
  read(Input, Token, [HOper | Output], TOper);
read(Input, {?OP, TokenValue = {_, TokenPrec, left, _}}, Output, OperatorStack = [{_, OperPrec, _, _} | _TOper]) when TokenPrec > OperPrec ->
  read(Input, ?UNDEF, Output, [TokenValue | OperatorStack]);
read(Input, {?OP, TokenValue = {_, TokenPrec, right, _}}, Output, OperatorStack = [{_, OperPrec, _, _} | _TOper]) when TokenPrec >= OperPrec ->
  read(Input, ?UNDEF, Output, [TokenValue | OperatorStack]);
read(Input, Token = {?OP, _TokenValue}, Output, [HOper | TOper]) ->
  read(Input, Token, [HOper | Output], TOper).

parse(Input) -> parse(Input, []).

parse([], [Result]) ->
  Result;
parse([HInput | TInput], Stack) when is_integer(HInput) ->
  parse(TInput, [HInput | Stack]);
parse([{_, _, _, Operation} | TInput], Stack = [B, A | TStack]) ->
  OperationResult = Operation(A, B),
  parse(TInput, [OperationResult | TStack]).


operator(?POW_CODE) -> {power, 4, right, fun power/2};
operator(?MUL_CODE) -> {multiply, 3, left, fun multiply/2};
operator(?DIV_CODE) -> {divide, 3, left, fun divide/2};
operator(?PLU_CODE) -> {plus, 2, left, fun plus/2};
operator(?MIN_CODE) -> {minus, 2, left, fun minus/2};
operator(?OPB_CODE) -> {open_brackets, 0, nil, nil};
operator(?CLB_CODE) -> {close_brackets, 0, nil, nil}.

power(A, B) -> math:pow(A, B).
multiply(A, B) -> A * B.
divide(A, B) -> A / B.
plus(A, B) -> A + B.
minus(A, B) -> A - B.
