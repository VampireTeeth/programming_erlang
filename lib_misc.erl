-module(lib_misc).
-export([for/3,
         qsort/1, perms/1, filter/2,
         max/2, odds_and_evens/1, sleep/1, flush_buffer/0]).

for(Max, Max, F) -> [F(Max)];
for(I, Max, F) -> [F(I)|for(I+1, Max, F)].

qsort([]) -> [];
qsort([Pivot|T]) ->
    qsort([X || X <- T, X < Pivot]) ++
        [Pivot] ++
        qsort([X || X <- T, X >= Pivot]).

perms([]) -> [[]];
perms(L) -> [[H|T] || H <- L, T <- perms(L--[H])].

filter(P, [H|T]) ->
    case P(H) of
        true  -> [H|filter(P, T)];
        false -> filter(P, T)
    end;
filter(_, []) -> [].

max(X, Y) when X > Y -> X;
max(_, Y) -> Y.

odds_and_evens(L) -> odds_and_evens_acc(L, [], []).

odds_and_evens_acc([], Odds, Evens) ->
    {lists:reverse(Odds), lists:reverse(Evens)};
odds_and_evens_acc([H|T], Odds, Evens) ->
    case (H rem 2) of
        0 -> odds_and_evens_acc(T, Odds, [H|Evens]);
        1 -> odds_and_evens_acc(T, [H|Odds], Evens)
    end.

sleep(T) ->
    receive
    after T -> true
    end.

flush_buffer() ->
    receive
        _Any ->
            flush_buffer()
    after 0 ->
            true
    end.
