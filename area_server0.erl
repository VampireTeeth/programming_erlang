-module(area_server0).
-export([loop/0, rpc/2]).

rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
        Response ->
            Response
    end.

loop() ->
    receive
        {From, {rectangle, Width, Height}} ->
            From ! Width * Height,
            loop();
        {From, {square, Side}} ->
            From ! Side * Side,
            loop();
        {From, {circle, R}} ->
            From ! 3.1415926 * R * R,
            loop();
        {From, _} ->
            From ! {error, other},
            loop()
    end.
