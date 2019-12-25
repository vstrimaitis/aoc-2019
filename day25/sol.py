starting_commands = [
    "east",
    "take whirled peas",    # 1
    "east",
    "north",
    "take prime number",    # 2
    "south",
    "west",
    "north",
    "take coin",            # 3
    "west",
    "north",
    "west",
    "take astrolabe",       # 4
    "east",
    "south",
    "south",
    "take antenna",         # 5
    "north",
    "east",
    "south",
    "west",
    "north",
    "take fixed point",     # 6
    "north",
    "take weather machine", # 7
    "east",
    # "south"
]

items = list(map(lambda x: x[5:], filter(lambda x: x.startswith("take "), starting_commands)))
for item in items:
    starting_commands.append(f"drop {item}")
starting_commands.append("south")

# print("\n".join(starting_commands))

from subprocess import Popen, STDOUT, PIPE, run
from itertools import chain, combinations

def powerset(iterable):
    s = list(iterable)
    res = chain.from_iterable(combinations(s, r) for r in range(len(s)+1))
    res = filter(lambda x: len(x) > 0, res)
    return list(res)

p = Popen(["./intc", "in", "--ascii"], stdout=PIPE, stdin=PIPE)
p.stdin.write("\n".join(starting_commands).encode())
p.stdin.write("\n".encode())
p.stdin.flush()

all_combos = powerset(items)
i = 0

found_answer = False
while True:
    line = p.stdout.readline().decode("utf-8").strip()
    if found_answer and len(line) > 0:
        print(line)
    if line.startswith("A loud, robotic voice says"):
        if "are lighter" in line:
            print("Too much")
        elif "are heavier" in line:
            print("Too little")
        else:
            print("OK")
            found_answer = True
            print(line)
            continue
        print(f"Trying {all_combos[i]}")
        for item in all_combos[i]:
            p.stdin.write(f"take {item}\n".encode())
        p.stdin.write("south\n".encode())
        for item in all_combos[i]:
            p.stdin.write(f"drop {item}\n".encode())
        p.stdin.flush()
        i += 1
