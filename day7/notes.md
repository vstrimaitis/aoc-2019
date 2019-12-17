# Day 7: Amplification Circuit

[Problem description](https://adventofcode.com/2019/day/7)

## Running the program
```
# Prerequisite
sudo apt-get install fp-compiler

# Running
fpc sol.pas
./sol < in
```

## Language
[Pascal](https://en.wikipedia.org/wiki/Pascal_(programming_language))

## Notes
Back to the old old days of Pascal :) When I first saw the problem statement,
I though "oh man, gonna have to implement the IntCode interpreter again".
Since I'm solving this a little bit out of order, now I know, that there is
an IntCode problem every other day. This kinda makes my "new-language-every-day"
challenge that much harder, so I'll have to think about ways to reuse code
from previous days so that I don't have to rewrite this thing every time :)

Now a little bit about the problem. The statement sounds easy enough - just
generate all permutations of the list `[0, 1, 2, 3, 4]`, try running 5 
IntCode programs for each permutation and pick out the maximum result out
of all those. In my code, I defined a record type `IntCodeProgram`, which
holds the current state of some program. The state consists of three parts:
* `mem` - the memory values of the program
* `ip` - the instruction pointer of the program
* `halted` - a flag, indicating whether or not the program has halted

After defining such a type, I wrote a function `RunProgram(IntCodeProgram, Int32): Int32`,
which takes an IntCode program and a single number as input and produces a single
number as output. Since in this specific problem the I/O flow was very simple
(exactly one input (except for the first call) and then exactly one output), this
kind of implementation was enough.

Then I wrote a function `GeneratePermutations(IntArray, Int32): IntArray2d`, which
generates all permutations of the given list. It works in a very simple way:
given the current position `k`, try swapping it with each of the positions
`k+1`, `k+2`, and so on and then generate the permutations of `arr[k+1..n]`
recursively. Finally, collect all of the permutations into a single list of lists
and you're done.

Finally, the `RunAmps` functions takes as input the permutations and the input
IntCode program and runs the 5 instances of the program in series.

Part 2 wasn't too different, since my `IntCodeProgram` record type preserved state - 
I only needed to run the loop for a little bit longer :) To be honest, at first I
implemented the `RunProgram` function in a simpler way (it only took as input
the input program and a list of inputs), but after seeing part 2, I had to refactor.

All in all, I remembered why I don't like Pascal :) The last time I used it was
probably in school when I was just starting out with programming. I didn't like
the language back then, but now I thought, that maybe I will think differently
this time since I have more knowledge. Apparently, little me was right all along.
The problem seemed to be pretty simple to me, but it tooks way too much effort and
the resulting code is huge and ugly. Of course, I could spend some time refactoring,
but the overall coding experience was not very pleasant to me.