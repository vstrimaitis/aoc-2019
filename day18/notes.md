# Day 18: Many-Worlds Interpretation

[Problem description](https://adventofcode.com/2019/day/18)

## Running the program
```
./compile.sh
./sol < in
```

## Language
[C++](https://en.wikipedia.org/wiki/C%2B%2B)

## Notes
This was probably the hardest problem for me so far, but also the most
interesting. Basically what you need to do is construct a graph from the given
input and find the shortest path in it. How should the graph look? Well, there
might be multiple ways of building it, but I chose to encode it like this:
let's say that each of the graph's nodes contains a single letter, denoting
on which cell we are on now, and a bitmask of the keys which were already
obtained. We start from the node `(@, 0)` and find the shortest path to any
node where the mask is `11111...11` (that is, we have obtained all keys).
To find the shortest path I used Dijkstra's algorithm. Also, to speed up the
search, I constructed the graph not of the whole maze, but only between points
of interest - `@` and the keys (`a`, `b`, ...). Also, on each edge I saved which
keys are necessary to go from a node `u` to a node `v`. I constructed this
initial graph using a simple BFS.

For part two, the only change that I needed to make is to the state. Instead of
storing a single character and the bitmask, let's now store a string of
characters and a bitmask. This string of characters represent where we are
currently in each part of the maze (so the string has 4 characters in total).
The rest of the algorithm is exactly the same.

The final code is pretty ugly, but I wrote it relatively fast compared to other
days, because I chose to use C++, which I know quite well. I think it would've
taken me at least a full day to get this working on some unknown language,
because there were many small details were a single mistake would be hard to
find. As for the problem, I enjoyed it very much and I'm happy that AoC includes
harder problems like this one.