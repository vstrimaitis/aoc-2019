using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

namespace Day23
{
    enum ProgramStatus
    {
        Running,
        WaitingForInput,
        Halted
    }
    class IntCode
    {
        List<long> memory;
        int ip;
        long relBase;
        List<long> stdout;
        int unseenStdoutStart;
        public Queue<long> Stdin { get; private set; }
        public List<long> Stdout => stdout;
        public List<long> NewStdout
        {
            get
            {
                if (unseenStdoutStart >= stdout.Count) return new List<long>();
                var res = stdout.Skip(unseenStdoutStart).ToList();
                unseenStdoutStart = stdout.Count;
                return res;
            }
        }
        public bool HasNewStdout => unseenStdoutStart < stdout.Count;
        public ProgramStatus Status { get; private set; }

        public IntCode(string srcFile)
        {
            memory = File.ReadAllText(srcFile)
                .Split(",")
                .Select(x => long.Parse(x))
                .ToList();
            ip = 0;
            relBase = 0;
            Status = ProgramStatus.Running;
            Stdin = new Queue<long>();
            stdout = new List<long>();
            unseenStdoutStart = 0;
        }

        public void Write(long x)
        {
            Stdin.Enqueue(x);
            Run();
        }

        public void Run()
        {
            Status = ProgramStatus.Running;
            while (Status == ProgramStatus.Running)
            {
                if (ip >= memory.Count) expandMemory(ip + 1);
                long curr = memory[ip];
                // Console.WriteLine("{0} {1}", ip, curr);
                long opCode = curr % 100;
                List<int> args;
                switch (opCode)
                {
                    case 1:
                        args = getArgs(3);
                        memory[args[2]] = memory[args[0]] + memory[args[1]];
                        ip += 4;
                        break;
                    case 2:
                        args = getArgs(3);
                        memory[args[2]] = memory[args[0]] * memory[args[1]];
                        ip += 4;
                        break;
                    case 3:
                        args = getArgs(1);
                        if (Stdin.Count == 0)
                        {
                            Status = ProgramStatus.WaitingForInput;
                        }
                        else
                        {
                            memory[args[0]] = Stdin.Dequeue();
                            ip += 2;
                        }
                        break;
                    case 4:
                        args = getArgs(1);
                        stdout.Add(memory[args[0]]);
                        ip += 2;
                        break;
                    case 5:
                        args = getArgs(2);
                        if (memory[args[0]] != 0)
                        {
                            ip = (int)memory[args[1]];
                        }
                        else
                        {
                            ip += 3;
                        }
                        break;
                    case 6:
                        args = getArgs(2);
                        if (memory[args[0]] == 0)
                        {
                            ip = (int)memory[args[1]];
                        }
                        else
                        {
                            ip += 3;
                        }
                        break;
                    case 7:
                        args = getArgs(3);
                        memory[args[2]] = memory[args[0]] < memory[args[1]] ? 1 : 0;
                        ip += 4;
                        break;
                    case 8:
                        args = getArgs(3);
                        memory[args[2]] = memory[args[0]] == memory[args[1]] ? 1 : 0;
                        ip += 4;
                        break;
                    case 9:
                        args = getArgs(1);
                        relBase += memory[args[0]];
                        ip += 2;
                        break;
                    case 99:
                        Status = ProgramStatus.Halted;
                        break;
                    default:
                        throw new Exception(string.Format("Unrecognized opcode {0}", opCode));
                }
            }
        }

        private List<int> getArgs(int cnt)
        {
            var indices = new List<int>();
            long divider = 100;
            for (int i = 0; i < cnt; i++)
            {
                indices.Add((int)(memory[ip] / divider % 10));
                divider *= 10;
            }
            for (int i = 0; i < cnt; i++)
            {
                int m = indices[i];
                indices[i] =
                    m == 0
                    ? (int)memory[ip + i + 1]
                    : m == 1
                    ? ip + i + 1
                    : (int)(relBase + memory[ip + i + 1]);
            }
            for (int i = 0; i < cnt; i++)
            {
                expandMemory(indices[i] + 1);
            }
            return indices;
        }

        private void expandMemory(int newSize)
        {
            while (memory.Count < newSize)
            {
                memory.Add(0);
            }
        }
    }
}