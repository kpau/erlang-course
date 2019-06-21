%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Jun 2019 09:54
%%%-------------------------------------------------------------------
-module(test).
-author("knikolov").

-define(EXT, ".erl"). % file extension to look for
-define(MODS, "./Tasks/").

%% API
-export([dir/0, dir/1]).

%% scans both a module directory and a test directory, compiles the
%% modules inside and then call for tests to be ran.
%%
%% usage:
%%     tester:dir("./","./tests/").
dir() -> dir(?MODS).
dir(ModulePath) ->
  ModuleList = module_list(ModulePath),
  [compile(X) || X <- ModuleList],
  Tokens = tokens(ModuleList),
  test_all(Tokens),
  warnings(),
  cleanup(Tokens),
  ok.

%% assumes pre-compiled modules
test_all(Tokens) ->
  io:format("- Start All~n"),
  {AllTotal, AllPass, AllFail} = test_single(Tokens, {0, 0, 0}),
  io:format("- End All~n"),
  io:format("Total: ~p\t|\tPass: ~p\t|\tFail: ~p~n", [AllTotal, AllPass, AllFail]).

test_single([], Counts) -> Counts;
test_single([{File, Token} | T], {AllTotal, AllPass, AllFail}) ->
  io:format("\t> ~-45.45s\t", [File]),
  TestResults = (list_to_existing_atom(Token)):test(),
  {Total, Pass, Fail} = test_results(TestResults, {0, 0, 0}),
  print_tests({Total, Pass, Fail}),
  print_test(lists:reverse(TestResults)),
  test_single(T, {AllTotal + Total, AllPass + Pass, AllFail + Fail}).

test_results([], Counts) -> Counts;
test_results([Res | T], Counts) ->
  test_results(T, test_result(Res, Counts)).

test_result({pass, _}, {Total, Pass, Fail}) -> {Total + 1, Pass + 1, Fail};
test_result({fail, _}, {Total, Pass, Fail}) -> {Total + 1, Pass, Fail + 1}.

print_tests({Total, _, 0}) ->
  io:format("~p tests~n", [Total]),
  ok;
print_tests({Total, _, Fail}) ->
  io:format("~p tests\t\t~p fail~n", [Total, Fail]),
  ok.

print_test([]) -> ok;
print_test([{pass, _} | T]) -> print_test(T);
print_test([{fail, {Test, {module, Mod}, {line, Line}, {expression, Expr}, {expected, Expc}, {value, Val}}} | T]) ->
  io:format("[~p.erl:~p] ~p: (~p, ~p) ~p~n", [Mod, Line, Test, Expc, Val, Expr]),
  print_test(T).

cleanup(Tokens) ->
  [file:delete(T ++ ".beam") || {_, T} <- Tokens].

tokens(FileList) ->
  Split = [{File, lists:nth(1, string:tokens(File, "."))} || File <- FileList],
  [{Path, lists:last(string:tokens(File, "./"))} || {Path, File} <- Split].

%% get module .erl file names from a directory
module_list(Path) ->
  SameExt = fun(File) -> get_ext(File) =:= ?EXT end,
  Files = list_files_recursive(Path),
  lists:filter(SameExt, Files).

list_files_recursive(Path) -> list_files_recursive(Path, file:list_dir(Path), []).

list_files_recursive(Path, {error, _}, Files) ->
  [Path | Files];
list_files_recursive(Path, PathList, Files) ->
  {ok, PathContents} = PathList,
  loop(Path, PathContents, Files).

loop(_, [], Files) -> Files;
loop(Path, [Content | PathContents], Files) ->
  list_files_recursive(Path ++ "/" ++ Content, file:list_dir(Path ++ "/" ++ Content), Files) ++
  loop(Path, PathContents, Files).

%% find the extension of a file (length is taken from the ?EXT macro).
get_ext(Str) ->
  lists:reverse(string:sub_string(lists:reverse(Str), 1, length(?EXT))).

compile(FileName) ->
  compile:file(FileName, [report, verbose, export_all]).

warnings() ->
  Warns = [{Mod, get_warnings(Mod)} || {Mod, _Path} <- code:all_loaded(),
    has_warnings(Mod)],
  show_warnings(Warns).

has_warnings(Mod) ->
  is_list(get_warnings(Mod)).

get_warnings(Mod) ->
  proplists:get_value(test_warnings, Mod:module_info(attributes)).

show_warnings([]) -> ok;
show_warnings(Warns) ->
  io:format("These need to be tested better: ~n\t~p~n", [Warns]).
