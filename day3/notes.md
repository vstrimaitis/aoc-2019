# Day 3: Crossed Wires

[Problem description](https://adventofcode.com/2019/day/3)

## Running the program
```
docker pull avian2/fimpp
docker-compose up
```

## Language
[FIM++](https://esolangs.org/wiki/FiM++)

[Interpreter](https://github.com/avian2/fimpp)

## Notes
After reading the statement for the first part, the following solution came to
mind: start at the point `(0, 0)` and update the coordinates while reading the
directions from the input one-by-one. Also, keep a list of all the points that
you get. By doing this, we get a description of a polyline in the form of a list
of points. We can then take each pair of consecutive points and treat that as a
vertical or horizontal line segment. After we do the same thing for both lines
of the input, just check each segment from the first line against each segment
from the second line for intersections. Among existing intersections pick the
one with minimal `abs(x) + abs(y)`.

Seems easy enough, so I decided to choose another esolang for this. After
getting a suggestion on my [first day's post](https://www.reddit.com/r/adventofcode/comments/e4yi75/2019_day_1_rockstar_solution/)
from `u/moeris`, I decided to try the `FIM++` language.

The first problem I faced was getting the interpreter working. I first
downloaded the source for it and tried to build it, but that didn't go too well.
After reading a bit I'm guessing it has something to do with Scala's versions,
but I have never tried Scala (yet), so I didn't want to scratch my head for too
long. In the repository of the interpreter I saw another option - to use Docker.
That's what I finally went with, since it was much simpler (even though I still
had some problems on my Windows machine and had to resort to using docker-compose).

When I finally started to write the code, the first thing I wanted to get out of
my way was parsing the input. I wrote a simple single-pass parsing algorithm,
where I keep track of the current letter and number and save the intermediate
result whenever I encounter a comma symbol. To make things easier, I appended
a comma to the end of each input line.

One interesting issue came up while I was writing the parser: there is no way
(or at least I couldn't find one) to convert a character to an integer. So I had
to write a super ugly function with 10 `if` statements to do that by hand...

All in all, I struggled with the first part a little bit, but eventually got it
on first try. Now about the second part...

The idea was clear - take each intersection and walk along both paths to find
the distance, then take the intersection with minimal distance. I spent quite
some time implementing that, submitted the answer and... my answer was
incorrect! I started debugging, which was one hell of an experience - no syntax
highlighting, no helpful compiler messages, nothing! I spent maybe two hours
looking for errors by printing `"[DEBUG] something"` all over the place and
finally found an error in the first part of the code! I must've got lucky with
the first part, since it was buggy as hell... I finally managed to fix all the
bugs, submitted again and this time it was OK.

All in all, it was a fun experiment, but I'm never doing FIM++ in my life ever
again :D