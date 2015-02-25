-module(mymaps).
-export([count_characters/1]).

count_characters(Str) ->
    count_characters(Str, #{}).

count_characters([H|T], X) when is_map(X)->
    N = maps:get(H, X, 0),
    count_characters(T, maps:put(H, N + 1, X));
count_characters([], X) -> X.
