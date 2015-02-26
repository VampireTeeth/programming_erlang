-module(walks).
-export([plan_route/2]).


-type direction() :: east|south|west|north.
-type point() :: {integer(), integer()}.
-type direction() :: [{go, direction(), integer()}].

-spec plan_route(From, To) -> Route when
      From  :: point(),
      To    :: point(),
      Route :: route().
