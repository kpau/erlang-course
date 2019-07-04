%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jun 2019 18:02
%%%-------------------------------------------------------------------
-module(calc_read).
-author("knikolov").

%% API
-export([test/0, read/1]).

-include_lib("../../Test/assertion.hrl").
-include_lib("./calc.hrl").


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
  ?assertEqual([6, 1.4, 1, 1.6, ?MAX(3), 1, 2, ?PI, ?MUL, 4, ?DIV, ?SIN, ?PLU, 2, ?MIN(4)], read("min(6, max(1.4,1,1.6), 1 + sin(2*PI/4), 2)"))
].

%% Read input and parse from infix notation to Reverse Polish notation - Shunting-yard algorithm
read(Input) -> lists:reverse(read(Input, [], [])).

read([], Output, []) ->
  Output;
read([], Output, [H | OperatorStack]) ->
  read([], [H | Output], OperatorStack);
read([?SPACE_CODE | TInput], Output, OperatorStack) ->
  read(TInput, Output, OperatorStack);
read(Input = [?COMMA_CODE | _], Output, OperatorStack) ->
  {NewInput, NewOutput, NewOperatorStack} = read_comma(Input, Output, OperatorStack),
  read(NewInput, NewOutput, NewOperatorStack);
read(Input = [H | _], Output, OperatorStack) when ?IS_NUMBER(H) ->
  {NewInput, Number} = read_number(Input),
  {NewOutput, NewOperatorStack} = push_number(Number, Output, OperatorStack),
  read(NewInput, NewOutput, NewOperatorStack);
read(Input, Output, OperatorStack) ->
  {NewInput, Operator} = read_operator(Input),
  {NewOutput, NewOperatorStack} = push_operator(Operator, Output, OperatorStack),
  read(NewInput, NewOutput, NewOperatorStack).

read_comma([?COMMA_CODE | TInput], Output, [OpenBr = #op{name = open_brackets}, PrevOp = #op{n = ?ANY} | TOper]) ->
  NewPrevOp = PrevOp#op{n = -1},
  {TInput, Output, [OpenBr, NewPrevOp | TOper]};
read_comma([?COMMA_CODE | TInput], Output, [OpenBr = #op{name = open_brackets}, PrevOp = #op{n = N} | TOper]) ->
  NewPrevOp = PrevOp#op{n = N - 1},
  {TInput, Output, [OpenBr, NewPrevOp | TOper]};
read_comma([?COMMA_CODE | TInput], Output, OperatorStack = [#op{name = open_brackets} | _]) ->
  {TInput, Output, OperatorStack};
read_comma(Input = [?COMMA_CODE | _], Output, [HOper | TOper]) ->
  read_comma(Input, [HOper | Output], TOper).

%% Read token
read_number(Input) ->
  read_number(Input, []).
read_number([H | T], Digits) when ?IS_NUMBER(H) ->
  read_number(T, [H | Digits]);
read_number(Input, Digits) ->
  Number = number(lists:reverse(Digits)),
  {Input, Number}.

read_operator(Input) ->
  read_operator(Input, []).
read_operator(Input = [H | T], Letters) when not ?IS_NUMBER(H) ->
  case operator(Letters) of
    ?UNDEF -> read_operator(T, Letters ++ [H]);
    Operator -> {Input, Operator}
  end;
read_operator(Input, Letters) ->
  Operator = operator(Letters),
  {Input, Operator}.

%% Push token to respective stack
push_number(Number, Output, OperatorStack) ->
  {[Number | Output], OperatorStack}.

push_operator(Operator, Output, []) ->
  {Output, [Operator]};
push_operator(Operator = #op{name = open_brackets}, Output, OperatorStack) ->
  {Output, [Operator | OperatorStack]};
push_operator(Operator = #op{name = close_brackets}, Output, [OpenBr = #op{name = open_brackets}, PrevOp = #op{n = ?ANY} | TOper]) ->
  NewPrevOp = PrevOp#op{n = 0},
  push_operator(Operator, Output, [OpenBr, NewPrevOp | TOper]);
push_operator(Operator = #op{name = close_brackets}, Output, [OpenBr = #op{name = open_brackets}, PrevOp = #op{n = N} | TOper]) when N < 0 ->
  NewPrevOp = PrevOp#op{n = (N - 1) * -1},
  push_operator(Operator, Output, [OpenBr, NewPrevOp | TOper]);
push_operator(#op{name = close_brackets}, Output, [#op{name = open_brackets}, PrevOp = #op{is_fun = true} | TOper]) ->
  {[PrevOp | Output], TOper};
push_operator(#op{name = close_brackets}, Output, [#op{name = open_brackets} | TOper]) ->
  {Output, TOper};
push_operator(Operator = #op{name = close_brackets}, Output, [HOper | TOper]) ->
  push_operator(Operator, [HOper | Output], TOper);
push_operator(Operator = #op{prec = TokenPrec, assoc = left}, Output, OperatorStack = [#op{prec = OperPrec} | _TOper]) when TokenPrec > OperPrec ->
  {Output, [Operator | OperatorStack]};
push_operator(Operator = #op{prec = TokenPrec, assoc = right}, Output, OperatorStack = [#op{prec = OperPrec} | _TOper]) when TokenPrec >= OperPrec ->
  {Output, [Operator | OperatorStack]};
push_operator(Operator, Output, [HOper | TOper]) ->
  push_operator(Operator, [HOper | Output], TOper).

