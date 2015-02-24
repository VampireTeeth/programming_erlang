-module(shop).
-export([cost/1, total0/1, total1/1, total2/1]).
-import(lists, [map/2, sum/1]).

cost(oranges) -> 5;
cost(apples) -> 8;
cost(newspaper) -> 4;
cost(pears) -> 9;
cost(milk) -> 7.

total0([{What, N}|T]) ->
    cost(What) * N + total0(T);
total0([]) -> 0.

total1(L) ->
    F = fun({What, N}) -> cost(What) * N end,
    sum(map(F, L)).

total2(L) ->
    sum([cost(What) * N || {What, N} <- L]).
