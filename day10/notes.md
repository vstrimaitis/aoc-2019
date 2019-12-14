# Day 10: Monitoring Station

[Problem description](https://adventofcode.com/2019/day/10)

## Running the program
```
# Install stack
stack run <input_file_path>
```

## Language
[Haskell](https://en.wikipedia.org/wiki/Haskell_(programming_language))

## Notes
Idea for the first part: for each asteroid:
* calculate the vector from this asteroid to every other asteroid
* normalize the vector
* take only unique vectors
* the size of the resulting list if the answer

This works because if two asteroids are in the same line of sight,
they will produce the same normalized vector.

The idea for the second part: try to sort all the coordinates 
according to how long it will take until the rotation reaches it.
To do this, let's execute the following procedure:
* find the unique slopes (just like in the first part)
* for each slope, find the closest asteroid, which produces this slope
* collect the IDs of these asteroids into a list `idsToTake`
* sort these asteroids by the angle it produces with the center asteroid
* build a list of all other coordinates, which are not in the `idsToTake` list
* solve for the left over coordinates recursively