-module(dist_demo).
-export([start/1, loop/0, rpc/4]).


start(Node) ->
    spawn(Node, fun() -> loop() end).


rpc(Pid, M, F, A) ->
    Pid ! {self(), {rpc, M, F, A}},
    receive
        {Pid, Response} ->
            Response
    end.

loop() ->
    receive
        {From, {rpc, M, F, A}} ->
            From ! {self(), catch apply(M, F, A)}
    end,
    loop().
