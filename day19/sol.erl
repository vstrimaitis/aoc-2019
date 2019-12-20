-module(sol).
-export([solve1/0, solve2/0]).

type(X, Y) -> string:trim(
    os:cmd(
        "echo \"" ++ integer_to_list(X) ++ " " ++ integer_to_list(Y) ++ "\" | ./intc in"
    )
).

dump_coords(X, Y) -> 
    io:put_chars(integer_to_list(X)),
    io:put_chars(" "),
    io:put_chars(integer_to_list(Y)),
    io:put_chars("\n").

count(_, Y, _, H) when Y == H -> 0;
count(X, Y, W, H) when X == W -> count(0, Y+1, W, H);
count(X, Y, W, H) ->
    list_to_integer(type(X, Y)) + count(X+1, Y, W, H).

solve1() ->
    io:put_chars(integer_to_list(count(0, 0, 50, 50))),
    io:put_chars("\n").

find_square(X, Y, Size) ->
    Type = list_to_integer(type(X, Y)),
    dump_coords(X, Y),
    if
        Type == 0 ->
            find_square(X+1, Y, Size);
        true ->
            if
                Y-Size+1 < 0 ->
                    find_square(X, Y+1, Size);
                true ->
                    OppositeType = list_to_integer(type(X+Size-1, Y-Size+1)),
                    if
                        OppositeType == 1 ->
                            X*10000 + (Y-Size+1);
                        true ->
                            find_square(X, Y+1, Size)
                    end
            end
    end.

solve2() ->
    io:put_chars(integer_to_list(find_square(0, 10, 100))),
    io:put_chars("\n").