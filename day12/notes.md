# Day 12: The N-Body Problem

[Problem description](https://adventofcode.com/2019/day/12)

## Running the program
```
# To install: follow the instructions at https://guide.elm-lang.org/install/elm.html
elm reactor
# Navigate to localhost:8000 in your browser, go to src -> Main
```

## Language
[Elm](https://en.wikipedia.org/wiki/Elm_(programming_language))

## Notes
The solution of the first part was trivial - simply simulate what is given
in the statement and get the answer. Nevertheless, it took me quite some
time to actually implement the logic, since I haven't tried Elm before
(like most of the languages I used so far). Since Elm works in the browser,
to solve the problem you have to do the following: paste your input in the
text area, input the number of iterations that you want to simulate and
click "Run part 1".

Part 2 seemed to be trickier, since you actually couldn't simply simulate
the process to get the solution. The idea here was to notice, that the
motions on separates axes are independent. That is, the position and
velocity on the x axis does not depend on the y or z axes. So we can
run the simulation for each of the axes separately. After doing that,
we get three numbers (say `xs`, `ys` and `zs`) - the number of steps
until we see the starting state for the first time. Then, to get the
final answer, just calculate the LCM (lowest common multiple) of
these three numbers. But... Elm doesn't have 64 bit integers, and
the numbers proved to be big enough to need them! I couldn't find
a good package with 64 bit integer support, so I simply printed out
the `xs`, `ys` and `zs` values after the simulation and calculated
the LCM by hand afterwards :)