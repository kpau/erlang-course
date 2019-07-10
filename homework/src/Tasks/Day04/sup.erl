%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Jul 2019 15:18
%%%-------------------------------------------------------------------
-module(sup).
-author("knikolov").
-include_lib("../../Test/assertion.hrl").

%% API
-export([test/0, start/2, start_link/2, init/1]).

test() -> [ ].

start(Mod,Args) ->
  spawn(?MODULE, init, [{Mod, Args}]).

start_link(Mod,Args) ->
  spawn_link(?MODULE, init, [{Mod, Args}]).

init({Mod,Args}) ->
  process_flag(trap_exit, true),
  loop({Mod,start_link,Args}).

loop({M,F,A}) ->
  Pid = apply(M,F,A),
  receive
    {'EXIT', _From, shutdown} ->
      exit(shutdown); % will kill the child too
    {'EXIT', Pid, Reason} ->
      io:format("Process ~p exited for reason ~p~n",[Pid,Reason]),
      loop({M,F,A})
  end.