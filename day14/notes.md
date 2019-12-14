# Day 14: Space Stoichiometry

[Problem description](https://adventofcode.com/2019/day/14)

## Running the program
```
# Install Rust before
cargo run
```

## Language
[Rust](https://en.wikipedia.org/wiki/Rust_(programming_language))

## Notes
Idea for the first part: construct a weighted directed graph from the input,
where the edge `(u, v)` with weight `w` indicates that you need `w` units
of `u` to produce one unit of `v`. Additionally, we will keep note of how many
units of each chemical are produced for each recipe. For example, if the input
is
```
2 A => 3 B
4 A => 5 C
1 B, 2 C => 6 D
```
we will construct a graph with the following edges:
```
A -> B (weight = 2)
A -> C (weight = 4)
B -> D (weight = 1)
C -> D (weight = 2)
```
and the `produces` values will be:
```
produces[B] = 3
produces[C] = 5
produces[D] = 6
```

Knowing that, we can perform a simple topological sort of the graph (starting
from the `FUEL` node). We will use this traversal of the graph to collect values
`needs[u]` for each node `u`. `needs[u]` represents how much of the value `u`
we will need to reach our goal. Initially, `needs[i] = 0` for each `i`, except
for `FUEL`, because `needs[FUEL] = 1`. Let's run the toposort: when examining a
node `u`, let's update each of its neighbours `v` by adding `needs[u]` to
`needs[v]`. Additionaly, we need to keep in mind the `produces[u]` values. For
example, if `produces[u] = 5` and `needs[u] = 8`, we would need to set
`needs[u] = 10` before examining the neighbours. That is because we cannot
partially apply recipes.

After running this algorithm, the answer of the first part will be `needs[ORE]`.

For the second part I reused all of the code from the first part. The only
change was to set the initial fuel count to some number `x` instead of `1`.
Once we can do that, we can run binary search on the value `x` and see if we
use up too much fuel or not.