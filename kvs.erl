-module(kvs).
-export([start/0, store/2, lookup/1]).


start() ->
    Pid = spawn(fun() -> loop() end),
    register(kvs, Pid).

store(Key, Val) ->
    rpc({store, Key, Val}).

lookup(Key) ->
    rpc({lookup, Key}).

rpc(Q) ->
    kvs ! {self(), Q},
    receive
        {kvs, Reply} -> Reply
    end.

loop() ->
    receive
        {From, {store, Key, Val}} ->
            put(Key, {ok, Val}),
            From ! {kvs, true};
        {From, {lookup, Key}} ->
            From ! {kvs, get(Key)}
    end,
    loop().
