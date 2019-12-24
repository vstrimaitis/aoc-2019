# Day 24: Planet of Discord

[Problem description](https://adventofcode.com/2019/day/24)

## Running the program
```
# Install node before running
node sol.js
```

## Language
[JavaScript](https://en.wikipedia.org/wiki/JavaScript)

## Notes
Part 1: simply simulate what is said in the problem statement. Be careful
not to go out of the bounds of the array.

Part 2: I keps the current state in an object of shape `{ level: board }`. When
doing an iteration, I added two empty board at either ends of the state (with
levels `minLevel-1` and `maxLevel+1`). Then I tried to calculate the updated
board for each level (taking into consideration the level above and below).
Finally, if any (or both) of the new boards that I added at either ends were
still empty, I removed them to prevent the state from exploding in size.

