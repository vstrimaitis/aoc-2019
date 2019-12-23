open System
open System.Diagnostics
open System.Collections.Generic
open System.Threading

let runProgram inputFile outputHandler =
    let startInfo =
        ProcessStartInfo(
            RedirectStandardOutput = true,
            RedirectStandardError = false,
            RedirectStandardInput = true,
            UseShellExecute = false,
            FileName = "./intc",
            Arguments = inputFile
        )
    let p = new Process(StartInfo = startInfo)
    p.OutputDataReceived.AddHandler(DataReceivedEventHandler(fun _ args -> outputHandler(args.Data)))
    p.Start() |> ignore
    p.BeginOutputReadLine()
    p

type Direction = Up | Down | Left | Right

let turn (currentDir: Direction) (turnDir: int) =
    match currentDir with
        | Up -> if turnDir = 0 then Left else Right
        | Down -> if turnDir = 0 then Right else Left
        | Left -> if turnDir = 0 then Down else Up
        | Right -> if turnDir = 0 then Up else Down

let walk (x: int) (y: int) (dir: Direction) =
    match dir with
        | Up -> (x, y-1)
        | Down -> (x, y+1)
        | Left -> (x-1, y)
        | Right -> (x+1, y)

let get (d: Dictionary<int*int, int>) (pt: int*int) =
    if not (d.ContainsKey pt) then 0 else d.[pt]

let draw (colors: Dictionary<int*int, int>) =
    let keys = colors.Keys
    let xs = keys |> Seq.toList |> List.map (fun (x, _) -> x)
    let ys = keys |> Seq.toList |> List.map (fun (_, y) -> y)
    let minX = xs |> List.min
    let maxX = xs |> List.max
    let minY = ys |> List.min
    let maxY = ys |> List.max
    for i in minY..maxY do
        for j in minX..maxX do
            let c = get colors (j, i)
            if c = 0 then
                Console.Write(" ")
            else
                Console.Write("#")
        Console.WriteLine()

[<EntryPoint>]
let main argv =
    let colors = new Dictionary<int*int, int>()
    let outputs = ref []
    let mutable x: int = 0
    let mutable y: int = 0
    let mutable dir: Direction = Up
    let mutable p: Process = null
    let outputHandler (line: string) =
        if not (String.IsNullOrWhiteSpace line) then
            // Console.WriteLine("[stdout] {0}", line)
            outputs := (int line) :: !outputs
            let currentOutputs = !outputs
            if currentOutputs.Length % 2 = 0 then
                let color = currentOutputs.Tail.Head
                let turnDir = currentOutputs.Head
                // Console.WriteLine("Got pair {0} {1}, dir={2}, x={3}, y={4}", color, turnDir, dir, x, y)
                colors.[(x, y)] <- color
                dir <- turn dir turnDir
                let (newX, newY) = walk x y dir
                x <- newX
                y <- newY
                // Console.WriteLine("dir={0}, x={1}, y={2}, colors={3}", dir, x, y, colors)
                if not p.HasExited then
                    try
                        p.StandardInput.WriteLine (get colors (x, y))
                    with
                        | :? Exception -> ()
            // Console.WriteLine(colors.Count)

    // Part 1
    let solve1 () =
        Console.WriteLine("Starting part 1...")
        p <- runProgram "in" outputHandler
        p.StandardInput.WriteLine("0")
        p.WaitForExit()
        let answer1 = colors.Count
        Console.WriteLine("Part 1: {0}", answer1)

    // Part 2
    let solve2 () =
        Console.WriteLine("Starting part 2...")
        colors.[(0, 0)] <- 1
        p <- runProgram "in" outputHandler
        p.StandardInput.WriteLine("1")
        p.WaitForExit()
        Console.WriteLine("Part 2")
        draw(colors)
    
    // solve1()
    solve2()
    0