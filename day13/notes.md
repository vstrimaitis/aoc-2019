# Day 13: Care Package

[Problem description](https://adventofcode.com/2019/day/13)

## Running the program
```
# Installation
sudo add-apt-repository ppa:webupd8team/java
sudo apt update
sudo apt install oracle-java8-set-default
curl -s get.sdkman.io | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install groovy
# Running
groovy sol.groovy
```

## Language
[Groovy](https://en.wikipedia.org/wiki/Apache_Groovy)

## Notes
The first part was trivial - simply run the given program, take every
third number from the output and count the number of `2`'s in it.

The second part proved to be quite challenging because of the way I chose
to do IntCode challenges. Since I'm using an executable from day 9, I needed
to find a way to communicate with it from Groovy code. Luckily, Java has
a pretty convenient way of doing this, and since Java has it, Groovy can use
it as well. The tricky part here was correctly implement the communication,
because after each input command there is an unknown number of output commands.
For this reason I chose to execute the function, which listens to the IntCode
output, in a separate thread. Also, in the main thread I wrote a loop, which
continuosly produced input and piped it to the IntCode executable every 100ms.

The actual logic of playing the game is very simple - if the ball is currently
to the left of the paddle, output `-1`. If it's to the right - output `1`.
Otherwise, output `0`.

All in all, it's pretty impressive what can be done with IntCode. I hope to see
more challenges like this one. Also, it's a good thing that I figured out this
whole interaction thing - I'm sure I'll be able to reuse it during the other
days.