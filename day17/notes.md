# Day 17: Set and Forget

[Problem description](https://adventofcode.com/2019/day/17)

## Running the program
```
# Installation
sudo apt-get install php-cli
# Running
php sol.php
```

## Language
[PHP](https://en.wikipedia.org/wiki/PHP)

## Notes
The first part was quite easy as always - you can simply iterate through
the output of the IntCode program and find all patterns like this one:
```
?#?
###
?#?
```

For each pattern like this, multiply the `x` and `y` coordinates of the
center cell and add them all up.

The second part proved to be more interesting. First of all, you need to
construct the list of commands to traverse the whole path. Then, you need
to compress this list of commands. To do this, you need to make an observation,
that one of the subcommands (`A`, `B` or `C`) is going to be a prefix of the
original list. Therefore, we can iterate over all prefixes and try to set that
prefix as `A`. After that, replace all occurences of this prefix to obtain a
new list of commands. To obtain `B` and `C` simply repeat the same process, just
be sure to not include `A` or `B` in the new prefix. After doing this, check if
the length of all three new commands is at most 20 and that the final command
list consists only of `A`, `B` and `C`. If all of this holds, run the IntCode
program again and provide the values as input and you'll get the answer for part

I used PHP for this challenge and I didn't really like the language itself.
Sure, it wasn't very hard to write the code, since the language is pretty high
level (especially compared to some of the other languages that I used during
the other days), but some things were very annoying for me (for example,
prefixing all variables with `$` seems just plain stupid to me). All in all,
it seems like an OK language, but it's just not for me.