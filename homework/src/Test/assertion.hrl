%%%-------------------------------------------------------------------
%%% @author knikolov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Jun 2019 17:59
%%%-------------------------------------------------------------------
-define(assertEqual(Expect, Expr),
  begin
    ((fun(__X) ->
      case (Expr) of
        __X -> {pass,
          {
            assertEqual,
            {module, ?MODULE},
            {line, ?LINE},
            {expression, (??Expr)},
            {expected, __X},
            {value, __X}
          }};
        __V -> {fail,
          {
            assertEqual,
            {module, ?MODULE},
            {line, ?LINE},
            {expression, (??Expr)},
            {expected, __X},
            {value, __V}
          }}
      end
      end)(Expect))
  end).

-define(assertRun(Expr),
  begin
    ((fun() ->
      Result = Expr,
      {pass,
          {
            assertRun,
            {module, ?MODULE},
            {line, ?LINE},
            {expression, (??Expr)},
            {expected, nil},
            {value, Result}
          }}
      end)())
  end).

-define(assertNotException(Expr),
  begin
    ((fun() ->
      try (Expr) of
        __V -> {pass,
          {
            assertNotException,
            {module, ?MODULE},
            {line, ?LINE},
            {expression, (??Expr)},
            {value, __V}
          }}
      catch __C:__T -> {fail,
        {
          assertNotException,
          {module, ?MODULE},
          {line, ?LINE},
          {expression, (??Expr)},
          {class, __C},
          {term, __T}
        }}
      end
      end)())
  end).

-define(assertReceive(Timeout, Expect, Expr),
  begin
    ((fun(__X) ->
      Expr,
      receive
        Expect -> {pass,
          {
            assertReceive,
            {module, ?MODULE},
            {line, ?LINE},
            {expression, (??Expr)},
            {expected, __X},
            {value, __X}
          }}
      after Timeout ->
        receive
          __V -> {fail,
            {
              assertReceive,
              {module, ?MODULE},
              {line, ?LINE},
              {expression, (??Expr)},
              {expected, __X},
              {value, __V}
            }}
        after 0 -> {fail,
          {
            assertReceive,
            {module, ?MODULE},
            {line, ?LINE},
            {expression, (??Expr)},
            {expected, __X},
            {value, timeout}
          }}
        end
      end
      end)(Expect))
  end).

-define(assertNotReceive(Timeout, Expect, Expr),
  begin
    ((fun(__X) ->
      Expr,
      receive
        Expect -> {fail,
          {
            assertReceive,
            {module, ?MODULE},
            {line, ?LINE},
            {expression, (??Expr)},
            {expected, __X},
            {value, __X}
          }}
      after Timeout -> {pass,
        {
          assertReceive,
          {module, ?MODULE},
          {line, ?LINE},
          {expression, (??Expr)},
          {expected, __X},
          {value, timeout}
        }}
      end
      end)(Expect))
  end).
