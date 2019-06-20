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
-export([dir/0]).

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
  io:format("Start All~n"),
  [test_single(Token) || Token <- Tokens],
  io:format("End All~n").

test_single({F, T}) ->
  io:format(" > ~p~n", [F]),
  try (list_to_existing_atom(T)):test() of
    _ -> ok
  catch
    _:Shit -> io:format("~p~n", [Shit])
  end,
  io:format(" * done.~n").

cleanup(Tokens) ->
  [file:delete(T ++ ".beam") || {_, T} <- Tokens].

tokens(FileList) ->
  Split = [{ File, lists:nth(1, string:tokens(File, ".")) } || File <- FileList],
  [{Path, lists:last(string:tokens(File, "./"))}|| {Path, File} <- Split].

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
loop(Path, [Content|PathContents], Files) ->
  list_files_recursive(Path ++ "/" ++ Content, file:list_dir(Path ++ "/" ++ Content), Files) ++
  loop(Path, PathContents, Files).

%% find the extension of a file (length is taken from the ?EXT macro).
get_ext(Str) ->
  lists:reverse(string:sub_string(lists:reverse(Str), 1, length(?EXT))).

compile(FileName) ->
  compile:file(FileName, [report, verbose, export_all]).

warnings() ->
  Warns = [{Mod, get_warnings(Mod)} || {Mod,_Path} <- code:all_loaded(),
    has_warnings(Mod)],
  show_warnings(Warns).

has_warnings(Mod) ->
  is_list(get_warnings(Mod)).

get_warnings(Mod) ->
  proplists:get_value(test_warnings, Mod:module_info(attributes)).

show_warnings([]) -> ok;
show_warnings(Warns) ->
  io:format("These need to be tested better: ~n\t~p~n", [Warns]).
