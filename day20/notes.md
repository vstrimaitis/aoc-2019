# Day 20: Donut Maze

[Problem description](https://adventofcode.com/2019/day/20)

## Running the program
```
# Installation
sudo apt-get install lua5.2 luarocks
# Setup
eval "$(luarocks path)"
# Running
lua sol.lua
```

## Language
[Lua](https://en.wikipedia.org/wiki/Lua_(programming_language))

## Notes
Construct a graph from the input and do a BFS on it. Constructing the graph for
the first part is simple enough, For the second part we additionally need to
store the depth of the current level.