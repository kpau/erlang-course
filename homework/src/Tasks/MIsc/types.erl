%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Jun 2019 14:59
%%%-------------------------------------------------------------------
-module(types).
-author("knikolov").
-include_lib("../../Test/assertion.hrl").

%% API
-export([test/0, any_to_string/1]).

test() -> [
  ?assertEqual("test", any_to_string("test")),
  ?assertEqual("asd", any_to_string(asd)),
  ?assertEqual("45", any_to_string(45)),
  ?assertEqual("11.22", any_to_string(11.22))
].


any_to_string(Var) when is_atom(Var) -> atom_to_list(Var);
any_to_string(Var) when is_binary(Var) -> binary_to_list(Var);
any_to_string(Var) when is_bitstring(Var) -> bitstring_to_list(Var);
any_to_string(Var) when is_float(Var) -> float_to_list(Var, [{decimals, 10}, compact]);
any_to_string(Var) when is_integer(Var) -> integer_to_list(Var);
any_to_string(Var) when is_pid(Var) -> pid_to_list(Var);
any_to_string(Var) when is_tuple(Var) -> tuple_to_list(Var);
any_to_string(Var) when is_list(Var) -> Var.

