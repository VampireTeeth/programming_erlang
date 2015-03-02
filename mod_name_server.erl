-module(mod_name_server).
-export([start_me_up/3]).


start_me_up(MM, _ArgC, _ArgS) ->
    loop(MM).

loop(MM) ->
    receive
        {chan, MM, {store, Key, Val}} ->
            MM ! {send, kvs:store(Key, Val)};
        {chan, MM, {lookup, Key}} ->
            MM ! {send, kvs:lookup(Key)};
        {chan_closed, MM} -> true
    end,
    loop(MM).
