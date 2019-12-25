# Day 23: Category Six

[Problem description](https://adventofcode.com/2019/day/23)

## Running the program
```
# Install dotnet core before running
dotnet run
```

## Language
[C#](https://en.wikipedia.org/wiki/C_Sharp_(programming_language))

## Notes
My idea today was to do the simulation in iteration. Each iteration consists
of these operations:
* Execute each program with the current input queue
* Capture output of each program and add data to other programs' input queues.

At first I tried to do this using my compiled IntCode interpreter from day 9,
but for some reason creating 50 processes proved to be very slow and I needed
to add around a minute of sleep between iterations to let the output update
correctly. I didn't want to waste more time thinking how to overcome this,
so I reimplemented the interpreter in C# and ran the logic with the new
implementation and it worked fine.

For part 2, the only things that needed to be changed were:
* Keep track of the last packet sent to the NAS
* Determine if the network is idle and then execute NAS logic

Determining whether or not the network is idle happened throughout the actual
iteration. If during the iteration
* Any process had some input in its queue OR
* Any process had new outputs at the end of the iteration

then the iteration is considered **not** idle. Otherwise, it's idle and we can
execute the NAS logic.

All in all, this was once again a pretty interesting puzzle that made use of
the IntCode language in a new and fun way. I don't think the challenge was too
hard, but it was very enjoyable nonetheless.