using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Threading;

namespace Day23
{
    class Program
    {
        static void Main(string[] args)
        {
            const int ProcessCount = 50;
            var processes = new List<IntCode>();
            for (int i = 0; i < ProcessCount; i++)
            {
                var p = new IntCode("in");
                p.Write(i);
                processes.Add(p);
            }
            int iterationCount = 0;
            long? ans1 = null;
            long? ans2 = null;
            (long, long)? natPacket = null;
            var natSentYValues = new List<long>();
            while (!ans1.HasValue || !ans2.HasValue)
            {
                Console.WriteLine("Iteration #{0}", iterationCount++);
                bool networkIdle = true;
                for (int i = 0; i < ProcessCount; i++)
                {
                    if (processes[i].Stdin.Count == 0)
                    {
                        processes[i].Stdin.Enqueue(-1);
                    }
                    else
                    {
                        networkIdle = false;
                    }
                    processes[i].Run();
                }
                for (int i = 0; i < ProcessCount; i++)
                {
                    var output = processes[i].NewStdout;
                    if (output.Count % 3 != 0)
                    {
                        Console.WriteLine("Something went wrong - wrong output length");
                        Console.WriteLine(string.Join(", ", output[i]));
                        continue;
                    }
                    if (output.Count > 0)
                    {
                        networkIdle = false;
                    }
                    for (int j = 0; j < output.Count; j += 3)
                    {
                        long dest = output[j];
                        long x = output[j + 1];
                        long y = output[j + 2];
                        if (dest == 255)
                        {
                            if (!ans1.HasValue) ans1 = y;
                            // Console.WriteLine("Sending to NAT: {0} {1}", x, y);
                            natPacket = (x, y);
                            continue;
                        }
                        processes[(int)dest].Stdin.Enqueue(x);
                        processes[(int)dest].Stdin.Enqueue(y);
                    }
                }

                if (networkIdle)
                {
                    if (!natPacket.HasValue)
                    {
                        throw new Exception("Network is idle, but NAT has not packets");
                    }
                    var (x, y) = natPacket.Value;
                    // Console.WriteLine("Network is idle. Sending ({0}, {1})", x, y);
                    natSentYValues.Add(y);
                    if (natSentYValues.Count >= 2 && natSentYValues[natSentYValues.Count - 1] == natSentYValues[natSentYValues.Count - 2])
                    {
                        ans2 = y;
                        continue;
                    }
                    processes[0].Stdin.Enqueue(x);
                    processes[0].Stdin.Enqueue(y);
                }
            }
            Console.WriteLine("Part 1: {0}", ans1.Value);
            Console.WriteLine("Part 2: {0}", ans2.Value);
        }
    }
}
