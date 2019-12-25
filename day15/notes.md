# Day 15: Oxygen System

[Problem description](https://adventofcode.com/2019/day/15)

## Running the program
```
javac Main.java
java Main
```

## Language
[Java](https://en.wikipedia.org/wiki/Java_(programming_language))

## Notes
This was another interesting and fun use of the IntCode programs. The basic idea
is quite simple - run some graph search algorithm (e.g. DFS) to explore a maze.
The only difference from the usual way this is done is that you have to get the
types of cells by using the IntCode program.

I implemented a wrapper class for the underlying IntCode executable to make it
easy for myself to use this in the actual logic. The logic itself is quite
standard: when you are at a node `u`, try probing each of its neighbours (up,
down, left and right). For each non-wall neighbour, run the DFS algorithm
recursively.

The second part was pretty much the same, but instead of using the IntCode
executable to get information about the maze, you should simply reuse the
information from part 1.

One guess that I made was that the maze would be without loops or open spaces.
If it had such properties, you couldn't use DFS, because it might not find 
the shortest path in that case. But this time DFS proved to be enough, because
the maze was a simple one.
