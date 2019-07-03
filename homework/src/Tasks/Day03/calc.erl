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

-record(op, {name, prec, assoc, func, n}).
-record(tk, {type, value}).

%% Tokens
-define(UNDEF, undefined).
-define(NUM, number).
-define(OP, operator).

%% ASCII codes
-define(ZERO_CODE, 48).
-define(NINE_CODE, 57).
-define(SPACE_CODE, 32).

%% Operators
-define(MAX(N), (operator("max"))#op{n = N}).
-define(MIN(N), (operator("min"))#op{n = N}).
-define(SIN, operator("sin")).
-define(COS, operator("cos")).
-define(POW, operator("^")).
-define(MUL, operator("*")).
-define(DIV, operator("/")).
-define(PLU, operator("+")).
-define(MNS, operator("-")).

-define(PI, math:pi()).
-define(PREC, 10).

-define(IS_NUMBER(H), ((H >= ?ZERO_CODE andalso H =< ?NINE_CODE) orelse H =:= 46 orelse (H >= 65 andalso H =< 90))).

%% API
-export([test/0, calculate/1, read/1, parse/1]).

test() -> [
  ?assertEqual([], read("")),
  ?assertEqual([5], read("5")),
  ?assertEqual([2, 3, ?PLU], read("2+3")),
  ?assertEqual([1, 2, ?MUL, 3, ?PLU], read("1*2+3")),
  ?assertEqual([1, 2, 3, ?PLU, ?MUL], read("1*(2+3)")),
  ?assertEqual([1, 2, ?MUL, 3, ?PLU], read("(1*2)+3")),
  ?assertEqual([1, 2, ?MNS, 3, ?DIV], read("(1-2)/3")),
  ?assertEqual([3, 4, 2, ?MUL, 1, 5, ?MNS, 2, 3, ?POW, ?POW, ?DIV, ?PLU], read("3+4*2/(1-5)^2^3")),
  ?assertEqual([3, 4, 2, ?MUL, 1, 5, ?MNS, 2, 3, ?POW, ?POW, ?DIV, ?PLU], read("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3")),
  ?assertEqual([315, 24, 122, ?MUL, 108, 65, ?MNS, 12, 30, ?POW, ?POW, ?DIV, ?PLU], read("315 + 24 * 122 / ( 108 - 65 ) ^ 12 ^ 30")),
  ?assertEqual([30, 64, 8, ?MUL, 5, 3, ?MNS, 2, 3, ?POW, ?POW, ?DIV, ?PLU], read("30 + 64 * 8 / (5-3) ^2 ^3")),
  ?assertEqual([6, 9, ?MAX(2)], read("max(6, 9)")),
  ?assertEqual([6, 9, 4, ?MAX(3), 2, 3, 1, 5, ?MIN(4), ?PLU], read("max(6, 9, 4) + min(2, 3, 1, 5)")),
  ?assertEqual([?PI, ?SIN], read("sin(PI)")),
  ?assertEqual([2, ?PI, ?MUL, 4, ?DIV, ?SIN, 2, ?PI, ?MUL, 3, ?DIV, ?COS, ?PLU], read("sin(2*PI / 4) + cos(2*PI / 3)")),

  ?assertEqual(5, parse([5])),
  ?assertEqual(5, parse([2, 3, ?PLU])),
  ?assertEqual(10, parse([2, 3, ?MUL, 4, ?PLU])),
  ?assertEqual(50, parse([10, 2, 3, ?PLU, ?MUL])),
  ?assertEqual(23, parse([10, 2, ?MUL, 3, ?PLU])),
  ?assertEqual(2.0, parse([8, 2, ?MNS, 3, ?DIV])),
  ?assertEqual(32.0, parse([30, 64, 8, ?MUL, 5, 3, ?MNS, 2, 3, ?POW, ?POW, ?DIV, ?PLU])),
  ?assertEqual(9, parse([6, 9, ?MAX(2)])),
  ?assertEqual(10, parse([6, 9, 4, ?MAX(3), 2, 3, 1, 5, ?MIN(4), ?PLU])),
  ?assertEqual(0.5, parse([2, ?PI, ?MUL, 4, ?DIV, ?SIN, 2, ?PI, ?MUL, 3, ?DIV, ?COS, ?PLU])),

  ?assertEqual(5, calculate("5")),
  ?assertEqual(5, calculate("2+3")),
  ?assertEqual(32.0, calculate("30 + 64 * 8 / (5-3) ^2 ^3")),
  ?assertEqual(9, calculate("max(6, 9)")),
  ?assertEqual(10, calculate("max(6, 9, 4) + min(2, 3, 1, 5)")),
  ?assertEqual(0.5, calculate("sin(2*PI / 4) + cos(2*PI / 3)")),
  ?assertEqual(1, 1)
].

calculate(Input) ->
  Rpn = read(Input),
  parse(Rpn).

%% Read input and parse from infix notation to Reverse Polish notation - Shunting-yard algorithm
read(Input) -> lists:reverse(read(Input, ?UNDEF, [], [])).

%% Remove whitespace and commas
read([?SPACE_CODE | TInput], Token, Output, OperatorStack) ->
  read(TInput, Token, Output, OperatorStack);
read([44 | TInput], Token, Output, OperatorStack) ->
  read(TInput, Token, Output, OperatorStack);

%% Token: None
read([], ?UNDEF, Output, []) ->
  Output;
read([], ?UNDEF, Output, [H | OperatorStack]) ->
  read([], ?UNDEF, [H | Output], OperatorStack);
read(Input, ?UNDEF, Output, OperatorStack) ->
  {NewInput, Token} = read_token(Input),
  read(NewInput, Token, Output, OperatorStack);

%% Token: Number
read(Input, {?NUM, TokenValue}, Output, OperatorStack = [OpenBr = #op{name = open_brackets}, PrevOp = #op{n = any} | T]) ->
  NewPrevOp = PrevOp#op{n = -1},
  read(Input, ?UNDEF, [TokenValue | Output], [OpenBr, NewPrevOp | T]);
read(Input, {?NUM, TokenValue}, Output, OperatorStack = [OpenBr = #op{name = open_brackets}, PrevOp = #op{n = N} | T]) when N < 0 ->
  NewPrevOp = PrevOp#op{n = N - 1},
  read(Input, ?UNDEF, [TokenValue | Output], [OpenBr, NewPrevOp | T]);
read(Input, {?NUM, TokenValue}, Output, OperatorStack) ->
  read(Input, ?UNDEF, [TokenValue | Output], OperatorStack);

%% Token: Operator
read(Input, {?OP, TokenValue}, Output, []) ->
  read(Input, ?UNDEF, Output, [TokenValue]);
read(Input, {?OP, TokenValue = #op{name = open_brackets}}, Output, OperatorStack) ->
  read(Input, ?UNDEF, Output, [TokenValue | OperatorStack]);
read(Input, Token = {?OP, _TokenValue = #op{name = close_brackets}}, Output, [#op{name = open_brackets}, PrevOp = #op{n=N} | TOper]) when N < 0 ->
  NewPrevOp = PrevOp#op{n=N*-1},
  read(Input, ?UNDEF, [NewPrevOp | Output], TOper);
read(Input, {?OP, _TokenValue = #op{name = close_brackets}}, Output, [#op{name = open_brackets} | TOper]) ->
  read(Input, ?UNDEF, Output, TOper);
read(Input, Token = {?OP, _TokenValue = #op{name = close_brackets}}, Output, [HOper | TOper]) ->
  read(Input, Token, [HOper | Output], TOper);
read(Input, {?OP, TokenValue = #op{prec = TokenPrec, assoc = left}}, Output, OperatorStack = [#op{prec = OperPrec} | _TOper]) when TokenPrec > OperPrec ->
  read(Input, ?UNDEF, Output, [TokenValue | OperatorStack]);
read(Input, {?OP, TokenValue = #op{prec = TokenPrec, assoc = right}}, Output, OperatorStack = [#op{prec = OperPrec} | _TOper]) when TokenPrec >= OperPrec ->
  read(Input, ?UNDEF, Output, [TokenValue | OperatorStack]);
read(Input, Token = {?OP, _TokenValue}, Output, [HOper | TOper]) ->
  read(Input, Token, [HOper | Output], TOper).

read_token(Input = [H | _]) when ?IS_NUMBER(H) ->
  read_token(Input, ?NUM, fun read_number/1);
read_token(Input) ->
  read_token(Input, ?OP, fun read_operator/1).

read_token(Input, Operator, ReadFn) ->
  {NewInput, TokenValue} = ReadFn(Input),
  {NewInput, {Operator, TokenValue}}.

read_number(Input) -> read_number(Input, []).

read_number([H | T], Digits) when ?IS_NUMBER(H) ->
  read_number(T, [H | Digits]);
read_number(Input, Digits) ->
  Number = number(Digits),
  {Input, Number}.

read_operator(Input) -> read_operator(Input, []).

read_operator(Input = [H | T], Letters) when not ?IS_NUMBER(H) ->
  case operator(Letters) of
    ?UNDEF -> read_operator(T, Letters ++ [H]);
    Operator -> {Input, Operator}
  end;
read_operator(Input, Letters) ->
  Operator = operator(Letters),
  {Input, Operator}.

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

number("IP") -> math:pi();
number(Number) ->
  N = lists:reverse(Number),
  case string:to_float(N) of
    {error, no_float} -> list_to_integer(N);
    {F, _} -> F
  end.

operator("max") ->
  #op{name = max, prec = 5, assoc = right, func = fun max/1, n = any};
operator("min") ->
  #op{name = min, prec = 5, assoc = right, func = fun min/1, n = any};
operator("sin") ->
  #op{name = sin, prec = 5, assoc = right, func = fun sin/1, n = 1};
operator("cos") ->
  #op{name = cos, prec = 5, assoc = right, func = fun cos/1, n = 1};
operator("^") ->
  #op{name = power, prec = 4, assoc = right, func = fun power/1, n = 2};
operator("*") ->
  #op{name = multiply, prec = 3, assoc = left, func = fun multiply/1, n = 2};
operator("/") ->
  #op{name = divide, prec = 3, assoc = left, func = fun divide/1, n = 2};
operator("+") ->
  #op{name = plus, prec = 2, assoc = left, func = fun plus/1, n = 2};
operator("-") ->
  #op{name = minus, prec = 2, assoc = left, func = fun minus/1, n = 2};
operator("(") ->
  #op{name = open_brackets, prec = 0, assoc = nil, func = nil, n = any};
operator(")") ->
  #op{name = close_brackets, prec = 0, assoc = nil, func = nil, n = any};
operator(_) ->
  ?UNDEF.

max(Numbers) -> lists:max(Numbers).
min(Numbers) -> lists:min(Numbers).
sin([A]) -> round(math:sin(A), ?PREC).
cos([A]) -> round(math:cos(A), ?PREC).
power([A, B]) -> math:pow(A, B).
multiply([A, B]) -> A * B.
divide([A, B]) -> round(A / B, ?PREC).
plus([A, B]) -> A + B.
minus([A, B]) -> A - B.

round(Number, Precision) ->
  P = math:pow(10, Precision),
  round(Number * P) / P.

