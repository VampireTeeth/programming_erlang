-module(records_play).
-export([clear_status/1]).
-include("records.hrl").

clear_status(#todo{status=S, who=W}=R) ->
    if
        S =:= finished, W =:= steven -> R#todo{status=S, who=W};
        true -> R#todo{status=finished, who=steven}
    end.
