# Day 11: Space Police

[Problem description](https://adventofcode.com/2019/day/11)

## Running the program
```
# Requires dotnet core
dotnet run
```

## Language
[F#](https://en.wikipedia.org/wiki/F_Sharp_(programming_language))

## Notes
Main idea: execute the program while keeping track of your position and
direction. Keep the colors of the visited tiles in a dictionary. After
the program halts, the answer of part 1 is the size of the dictionary.

For part 2, do the exact same thing just with the first tile painted white.
After the program halts, use the dictionary with values to print out the
actual pattern.
