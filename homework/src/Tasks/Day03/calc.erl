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

%% API
-export([test/0, calculate/1]).

-include_lib("../../Test/assertion.hrl").
-include_lib("./calc.hrl").


test() -> [
  ?assertEqual(5, calculate("5")),
  ?assertEqual(5, calculate("2+3")),
  ?assertEqual(32.0, calculate("30 + 64 * 8 / (5-3) ^2 ^3")),
  ?assertEqual(9, calculate("max(6, 9)")),
  ?assertEqual(10, calculate("max(6, 9, 4) + min(2, 3, 1, 5)")),
  ?assertEqual(0.5, calculate("sin(2*PI / 4) + cos(2*PI / 3)"))
].

calculate(Input) ->
  Rpn = calc_read:read(Input),
  calc_parse:parse(Rpn).

