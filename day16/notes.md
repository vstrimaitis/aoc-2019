# Day 16: Flawed Frequency Transmission

[Problem description](https://adventofcode.com/2019/day/16)

## Running the program
```
# Installation
sudo apt-get install r-base -y
# Running
Rscript sol.r
```

## Language
[R](https://en.wikipedia.org/wiki/R_(programming_language))

## Notes
For the first part it was enough to simply implement what was stated
in the problem description. I implemented a function with a loop,
which repeated 100 times. For each iteration, go through all indices,
generate the pattern (with another helper function) for each of them
and then use this pattern to calculate the value at index `i`. So this
was easy enough.

The second part required some insight. The main idea is the following:
if we are at iteration `t` and index `i`, this value is calculated
from iteration `t-1` indices `i+1...n`. This is because the pattern
at index `i` starts with `i-1` zeros, so the first `i-1` numbers are
irrelevant. Since the offset in the input is large, it only leaves about
half a million digits as the suffix. What is more, because of this large
offset we only need to add up the values from the previous iteration.
Therefore, the first element at iteration `t` is simply the sum of all of
the elements from iteration `t-1`, the second element is equal to the same
sum just without the first element of `t-1` and so on. Therefore, we can
calculate a single iteration in linear time.

This day's interesting fact: if you use loops in R they are super slow.
So if you can think of ways to write code without loops, you should do
that :)