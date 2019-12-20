open Utils
open Types
open Array
open String
open Printf

let parse_operation mem ip = match (mem.(ip) mod 100) with
    | 1 -> Add (
        mem.(ip)/100 mod 10,
        mem.(ip)/1000 mod 10,
        mem.(ip)/10000 mod 10)
    | 2 -> Mult (
        mem.(ip)/100 mod 10,
        mem.(ip)/1000 mod 10,
        mem.(ip)/10000 mod 10)
    | 3 -> Input mem.(ip+1)
    | 4 -> Output mem.(ip+1)
    | 5 -> JumpIfTrue (
        mem.(ip)/100 mod 10,
        mem.(ip)/1000 mod 10)
    | 6 -> JumpIfFalse (
        mem.(ip)/100 mod 10,
        mem.(ip)/1000 mod 10)
    | 7 -> LessThan (
        mem.(ip)/100 mod 10,
        mem.(ip)/1000 mod 10,
        mem.(ip)/10000 mod 10)
    | 8 -> Equals (
        mem.(ip)/100 mod 10,
        mem.(ip)/1000 mod 10,
        mem.(ip)/10000 mod 10)
    | 99 -> Termination
    | _ -> raise (Invalid_argument (Printf.sprintf "Found value %d at position %d" mem.(ip) ip))

let get_index mem i mode =
    if mode == 0 then mem.(i) else i

let map_triple f (a, b, c) = (f a, f b, f c)
let map_pair f (a, b) = (f a, f b)

let step : state -> state = function
    | Terminated out -> Terminated out
    | Running (mem, ip, out) -> match (parse_operation mem ip) with
        | Add (m1, m2, m3) -> ((m1, ip+1), (m2, ip+2), (m3, ip+3))
            |> map_triple (fun (m, i) -> get_index mem i m)
            |> fun (i1, i2, i3) -> mem.(i3) <- (mem.(i1)+mem.(i2));
            Running (mem, ip+4, out)
        | Mult (m1, m2, m3) -> ((m1, ip+1), (m2, ip+2), (m3, ip+3))
            |> map_triple (fun (m, i) -> get_index mem i m)
            |> fun (i1, i2, i3) -> mem.(i3) <- (mem.(i1)*mem.(i2));
            Running (mem, ip+4, out)
        | Input dest ->
            print_string "> ";
            read_line() |> int_of_string |> fun x -> mem.(dest) <- x;
            Running (mem, ip+2, out)
        | Output i -> Running (mem, ip+2, mem.(i)::out)
        | JumpIfTrue (m1, m2) -> ((m1, ip+1), (m2, ip+2))
            |> map_pair (fun (m, i) -> get_index mem i m)
            |> fun (i1, i2) -> 
                if mem.(i1) != 0
                then Running (mem, mem.(i2), out)
                else Running (mem, ip+3, out)
        | JumpIfFalse (m1, m2) -> ((m1, ip+1), (m2, ip+2))
            |> map_pair (fun (m, i) -> get_index mem i m)
            |> fun (i1, i2) -> 
                if mem.(i1) == 0
                then Running (mem, mem.(i2), out)
                else Running (mem, ip+3, out)
        | LessThan (m1, m2, m3) ->  ((m1, ip+1), (m2, ip+2), (m3, ip+3))
            |> map_triple (fun (m, i) -> get_index mem i m)
            |> fun (i1, i2, i3) -> 
                if mem.(i1) < mem.(i2)
                then mem.(i3) <- 1
                else mem.(i3) <- 0;
            Running (mem, ip+4, out)
        | Equals (m1, m2, m3) ->  ((m1, ip+1), (m2, ip+2), (m3, ip+3))
            |> map_triple (fun (m, i) -> get_index mem i m)
            |> fun (i1, i2, i3) -> 
                if mem.(i1) == mem.(i2)
                then mem.(i3) <- 1
                else mem.(i3) <- 0;
            Running (mem, ip+4, out)
        | Termination -> Terminated out

let rec run : state -> int list = function
    | Terminated out -> List.rev out
    | s -> run (step s)

let input = read_line()
    |> String.split_on_char ','
    |> List.map int_of_string
    |> Array.of_list;;

let start_state = Running(input, 0, []);;
let output = run start_state;;
print_string "Program's output: ";
print_list output;
print_string "\n";;
