type state =
    | Running of int array * int * int list
    | Terminated of int list

type operation =
    | Add of int * int * int
    | Mult of int * int * int
    | Input of int
    | Output of int
    | JumpIfTrue of int * int
    | JumpIfFalse of int * int
    | LessThan of int * int * int
    | Equals of int * int * int
    | Termination
