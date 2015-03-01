-module(linkmon).
-import(lib_misc, [sleep/1]).
-export([myproc/0, chain/1, start_critic/0, start_critic2/0, judge/3, judge2/2]).


myproc() ->
    lib_misc:sleep(5000),
    exit(reason).


chain(0) ->
    receive
        _ -> ok
    after 2000 ->
            exit("Chain dies here")
    end;
chain(N) ->
    process_flag(trap_exit, true),
    Pid = spawn_link(fun() -> chain(N-1) end),
    receive
        {'EXIT', Pid, normal} -> io:format("Process ~p exit normally.~n", [Pid]), ok;
        {'EXIT', Pid, Why} -> io:format("Process ~p exit with ~p~n", [Pid, Why]), ok;
        _ -> ok
    end.


start_critic() ->
    spawn(fun () -> critic() end).

start_critic2() ->
    spawn(fun () -> restarter() end).

restarter() ->
    process_flag(trap_exit, true),
    Critic = spawn_link(fun () -> critic2() end),
    register(critic, Critic),
    receive
        {'EXIT', Critic, normal} -> ok;
        {'EXIT', Critic, shutdown} -> ok;
        {'EXIT', Critic, _} -> io:format("Critic restarting...~n", []), restarter()
    end.

judge(Pid, Band, Album) ->
    Pid ! {self(), {Band, Album}},
    receive
        {Pid, Comment} ->
            Comment
    after 2000 ->
            timeout
    end.

judge2(Band, Album) ->
    Ref = make_ref(),
    critic ! {self(), Ref, {Band, Album}},
    receive
        {Ref, Comments} -> Comments
    after 2000 -> timeout
    end.


critic() ->
    receive
        {From, {"Rage against the turing machine", "Unit Testify"}} ->
            From ! {self(), "They are great!"};
        {From, {"System of a downtime", "Memoize"}} ->
            From ! {self(), "They are good!"};
        {From, {"Johnny Crash", "The token of ring"}} ->
            From ! {self(), "Incredible!"};
        {From, {_Band, _Album}} ->
            From ! {self(), "They are terrible!"}
    end,
    critic().

critic2() ->
    receive
        {From, Ref, {"Rage against the turing machine", "Unit Testify"}} ->
            From ! {Ref, "They are great!"};
        {From, Ref, {"System of a downtime", "Memoize"}} ->
            From ! {Ref, "They are good!"};
        {From, Ref, {"Johnny Crash", "The token of ring"}} ->
            From ! {Ref, "Incredible!"};
        {From, Ref, {_Band, _Album}} ->
            From ! {Ref, "They are terrible!"}
    end,
    critic2().
