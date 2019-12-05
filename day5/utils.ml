open Types
open List
open Array

let print_list l =
    print_string "[";
    List.iter (fun x -> print_int x; print_string " ") l;
    print_string "]";;

let print_array a =
    print_string "[|";
    Array.iter (fun x -> print_int x; print_string " ") a;
    print_string "|]";;

let print_state s = match s with
    Terminated out -> 
        print_string "Terminated. Output: ";
        print_list out
    | Running (mem, ip, out) ->
        print_string "mem=";
        print_array mem;
        print_string ", ip=";
        print_int ip;
        print_string ", out=";
        print_list out;;