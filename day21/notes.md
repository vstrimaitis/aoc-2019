# Day 21: Springdroid Adventure

[Problem description](https://adventofcode.com/2019/day/21)

## Running the program
```
./intc in --ascii
```

## Language
SpringScript, I guess?

## Notes
I used the IntCode interpreter from day 9 and figured out the actual
SpringScript programs by hand, so I guess I can call SpringScript today's
language of choice :)

Anyway, the first part was pretty intuitive for me and I got it quite
quickly. The logical expression for part 1 that I came up with was:
```
(!A | !B | !C) & D = !(A & B & C) & D
```
This means: if there is a floor tile 4 tiles away AND any
of the tiles between the current one and the one 4 tiles away
is missing - jump.

Part 2 took quite some trial and error - I started from very simple programs
and iterated on those until I got something that works. The final expression
turned out to be as follows:
```
D & (!A | (H & (!B | !C)))
```
This encodes the following logic:
* Jump only if the tile 4 tiles away (`D`) is a floor tile (otherwise - you ded)
* If the tile right in front of you is empty (`A`) is empty - jump
* Otherwise, look at tiles `B`, `C` and `H` and determine when to jump according to them.

The first parts are very intuitive, but the last one (with the `H`, `B` and `C`)
I got purely by fiddling around. The final program used up 8 commands (including
`RUN`), so I consider this a success, since we were given 15 command to play with.

All in all, I really liked this puzzle, even though there was no actual coding
this time (though I'm sure there are ways to figure out the SpringScript program
programatically).