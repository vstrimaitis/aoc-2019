# Day 19: Tractor Beam

[Problem description](https://adventofcode.com/2019/day/19)

## Running the program
```
# Installation
wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -
echo "deb https://packages.erlang-solutions.com/ubuntu bionic contrib" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
sudo apt update
sudo apt -y install erlang
# Running
erl
c(sol).
sol:solve1().
sol:solve2().
```

## Language
[Erlang](https://en.wikipedia.org/wiki/Erlang_(programming_language))

## Notes
This challenge seemed easy enough, so I decided to pick some lesser known
(for me) language. I picked Erlang. For the IntCode part I tried to reuse
the interpreter that I wrote in C on day 9. I used the `os:cmd` function
to invoke my `intc` executable from my erlang code and then do the actual
logic in erlang. I couldn't find a way to interact with the executable
int erlang (e.g. provide input through `stdin`, then read `stdout`, then
provide input through `stdin` again and so on), but it wasn't necessary
for this challenge.

I think there is no need to explain part 1, since you simply query all
of the points from (0, 0) to (49, 49) and count the number of 1's.

Part 2 was a little bit more tricky, since simple enumeration like in
part 1 is too slow. What I did instead was follow the lower edge of the
beam by going right until I hit a `1`, then going down, then right again
and so on. Whenever I hit a `1` at `(x, y)`, I would check whether the value
at `(x+99, y-99)` was a `1` as well. If that was true, it meant that I found
the answer `(x, y-99)`.

Since I was running the IntCode programs by executing an actual separate
executable, I was expecting the code to be a bit slower than it would
have been if I had implemented the interpreter in erlang itself. However,
it was actually **way** slower - both parts took maybe a few minutes on my
machine, whereas I would expect them to take a fraction of a second.
I'm not sure why this is the way it is, but probably `os:cmd` is the
bottleneck here.