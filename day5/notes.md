# Day 5: Sunny with a Chance of Asteroids

[Problem description](https://adventofcode.com/2019/day/5)

## Running the program
```
# Prerequisite
# apt install ocaml
ocamlc -o sol types.ml utils.ml sol.ml
./sol
```

## Language
[OCaml](https://ocaml.org/)

## Notes
This is a continuation of the 2nd day. Too bad, since I won't be able to reuse
the code from day 2, because I'm doing different languages every day :) Today
I decided to use OCaml. I wanted to use a functional language this time, because
this problem seemed like a pretty good fit (you basically need to write a function,
which takes in the previous state of the program and returns the new state).

I spent quite some time reading the documentation and trying out various constructs
to get a fell for the language. The final code isn't too pretty in my opinion, but
I didn't really have much time to look into it - maybe I'll come back some day.

The idea for the solution was basically the same as in day 2 - just walk along the
list of numbers and simulate the operations. Overall, this day was pretty calm,
mainly because of the language choice, since it had good docs and plenty of examples.