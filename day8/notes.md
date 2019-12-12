# Day 8: Space Image Format

[Problem description](https://adventofcode.com/2019/day/8)

## Running the program
```
# Installing
# [apt get install swipl](https://wwu-pi.github.io/tutorials/lectures/lsp/010_install_swi_prolog.html)
swipl -s sol.pl
# In the swipl run:
# solve1(Ans).
# solve2.
```

## Language
[Prolog](https://en.wikipedia.org/wiki/Prolog)

## Notes
The solution would be trivial if I had chosen a language where I could use
simple 2D arrays. But I chose Prolog instead, since the task seemed to be
at least *doable* in it, and I want to save the languages that I'm good at
for the end.

The first part asked to find a layer with the fewest zeros and then do some
simple calculations. To do this, I defined a few predicates:
* `grid` to convert the input string into a list of layers, where each layer
  is a list of rows and each row is a list of chars;
* `occurenceCount` to count the number of occurences of a specific character
  in a single layer;
* `bestLayer` to find the layer with the fewest zeros.

The second part proved to be a bit trickier to do in Prolog, mostly because
there is no easy way to index lists - you have to keep popping off items
from the list one by one. So I defined predicates to apply layers to an image
layer-by-layer and then row-by-row. After combining those, I ended up with
a list of characters, so I simply needed to join them into a single string
and print it out. To make the answer more readable, I decided to change '0'
to ' ' and '1' to '#' before printing.

One pretty cool (but small) thing I noticed: you can use the built-in predicate
`string_chars` in both ways - both to split a string into a list of characters
**and** to join a list of characters into a string.