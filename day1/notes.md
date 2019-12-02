# Day 1: The Tyranny of the Rocket Equation

[Problem description](https://adventofcode.com/2019/day/1)

## Running the program
```
# First time setup
git clone https://github.com/RockstarLang/rockstar
cd rockstar/satriani
npm i
cd ../..

# Running
node rockstar/satriani/rockstar sol.rock
# Paste the input into the console
```

## Language
[Rockstar](https://github.com/RockstarLang/rockstar)

## Notes
The first part of the problem is obvious - just do what you're told to do. However, since I
decided to use the Rockstar programming language, it wasn't as obvious. Apparently, Rockstar
doesn't have built in integer division, so I had to roll out my own :) I ended up doing it
in the simplest way possible, which, as one could expect, proved to be pretty slow. However,
it was good enough for this time. Also, the function's name is `Christmas`, because it sounded
best in the context (e.g. `Christmas takes joy and kindness`)

One interesting thing when writing the program was to think of names for variables, functions
and numbers(!), so that the whole program would make at least a little bit of sense. The numbers
took the longest time (I used the poetic number literals to represent numbers instead of plain
old boring digits).

The second part of the problem wasn't much harder - you just needed to do the same procedure
a bunch of times recursively.