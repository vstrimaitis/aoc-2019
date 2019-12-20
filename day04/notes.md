# Day 4: Secure Container

[Problem description](https://adventofcode.com/2019/day/4)

## Running the program
```
apt-get install sbcl
sbcl --script sol.lisp
```

## Language
[Common Lisp](https://en.wikipedia.org/wiki/Common_Lisp)

## Notes
After reading the first part this idea came to mind: since there are only six
digits, we can generate all possible 6-digit numbers and simply check how many
of them are in the required range and follow the rules. Since the task seemed
simple enough, I decided to use *Lisp*, even though I wasn't going to use it
at all.

The syntax of Lisp was pretty weird to me, but it was nowhere near the complexity
of the previous day, so I solved this one relatively fast.

The main idea was to generate numbers recursively while keeping some information
about the number being generated. The information I decided to keep was:
* `n`: The number of digits used to far. I only needed this part to know when to stop the recursion.
* `last`: The last digit used so far.
* `val`: The value of the number so far.
* `double`: Were any doubles (i.e. repeated digits) encountered so far?
* `low`: The lower bound (from the input).
* `high`: The upper bound (from the input).

If theses values are maintained correctly, then at the base case of the function
(i.e. when `n == 6`), we only need to check if `low <= val <= high` and
`double == 1`.

The second part was pretty much the same except I added another parameter to the
function called `len`, which indicated the length of the current group of digits.
If we manage to reach the base case with `len == 2`, then we definitely generated
a correct number. Otherwise, whenever we generate a digit `d`, which is different
from the previous digit (`last`), we check the value of `len`. If it is equal to
2, then we set `double` to 1, since we want to remember that we encountered a
repeated digit somewhere in the number.