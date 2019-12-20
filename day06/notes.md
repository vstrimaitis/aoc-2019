# Day 6: Universal Orbit Map

[Problem description](https://adventofcode.com/2019/day/6)

## Running the program
```
# Installing
# apt get install pike8.0
pike sol.pike
```

## Language
[Pike](https://en.wikipedia.org/wiki/Pike_(programming_language))

## Notes
The first part is pretty obvious if you're familiar with graph problems.
Basically, you are given a tree and need to calculate the sum of depths of all
the nodes. The "harder" parts here to me seemed to be parsing the input and
constructing the graph itself - I decided that I need strings and some sort of
associative arrays for this. I picked the Pike language, since from a short
look at the documentation it seems that this language has everything I need.

It took some time to get familiar with the built-in functions, but it didn't
take *too* long. I found all the information I needed [here](http://www.mit.edu/afs.new/sipb/project/pike/tutorial/tutorial_onepage.html).
The final solution for part 1 was fairly straightforward:
1. Read the input line-by-line
2. Split each line on the `)` character and get two strings `u` and `v`
3. For each such pair, add an edge between `u` and `v`
4. After reading the whole input, run a DFS (depth-first search) from the node
   `COM`. This dfs (called `dfs1` in my code) returns the sum of depths of the
   subtree rooted at some node `u`. Since the root of the given tree is `COM`,
   we get the required answer if we simply start the DFS from this node.

The second part basically asked to find the distance between nodes `YOU` and
`SAN`. I reused much of the logic from the first part to do this. The only
thing that changed is this: we keep an additional value `goal` in the DFS. If
the current node is the goal, simply return the current depth. Otherwise,
examine all neighbours of the current node `u` one by one. If you run DFS on
a neighbour `v` and it doesn't return `0`, it means that a path to `goal` was
found and we can immediately return. If no path is found, just return `0`.

Running this algorithm with the tree rooted at `YOU` and the goal set to `SAN`,
we get the correct answer.

Overall, today was probably the easiest day so far for me, mainly because the
language I chose is quite similar to the other languages I know (in particular,
C++).