%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jun 2019 18:02
%%%-------------------------------------------------------------------
-author("knikolov").

-record(op, {name, prec, assoc, func, n, is_fun = false}).
-record(tk, {type, value}).

-define(UNDEF, undefined).
-define(ANY, any).

%% ASCII codes
-define(ZERO_CODE, 48).
-define(NINE_CODE, 57).
-define(SPACE_CODE, 32).
-define(DOT_CODE, 46).
-define(COMMA_CODE, 44).
-define(A_CODE, 65).
-define(Z_CODE, 90).

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

-define(PI, number("PI")).
-define(E, number("E")).

-define(PREC, 14).

-define(IS_NUMBER(H), ((H >= ?ZERO_CODE andalso H =< ?NINE_CODE) orelse H =:= ?DOT_CODE orelse (H >= ?A_CODE andalso H =< ?Z_CODE))).
%% API
-export([]).

%% Cast number
number("E") -> 2.718281828459045;
number("PI") -> math:pi();
number(N) ->
  case string:to_float(N) of
    {error, no_float} -> list_to_integer(N);
    {F, _} -> F
  end.

%% Cast Operator
operator("max") ->
  #op{name = max, prec = 5, assoc = right, func = fun max/1, n = ?ANY, is_fun = true};
operator("min") ->
  #op{name = min, prec = 5, assoc = right, func = fun min/1, n = ?ANY, is_fun = true};
operator("sin") ->
  #op{name = sin, prec = 5, assoc = right, func = fun sin/1, n = 1, is_fun = true};
operator("cos") ->
  #op{name = cos, prec = 5, assoc = right, func = fun cos/1, n = 1, is_fun = true};
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
  #op{name = open_brackets, prec = 0, assoc = ?UNDEF, func = ?UNDEF, n = ?ANY};
operator(")") ->
  #op{name = close_brackets, prec = 0, assoc = ?UNDEF, func = ?UNDEF, n = ?ANY};
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


