{$H+}
program Hello;

type IntArray = array of Int64;
type IntArray2d = array of IntArray;
type
  IntCodeProgram = record
    mem: IntArray;
    ip: Int64;
    halted: Boolean;
  end;

function CreateProgram(prog: IntArray): IntCodeProgram;
begin
  CreateProgram.mem := prog;
  CreateProgram.ip := 0;
  CreateProgram.halted := false;
end;

function Split(s: string; delim: char): IntArray;
var
  commaCount: Int64;
  c: char;
  currentNumber: Int64;
  sign: Int64;
begin
  sign := 1;
  commaCount := 0;
  for c in s do
    if c = delim then
      commaCount := commaCount + 1;

  setLength(Split, commaCount+1);
  currentNumber := 0;
  for c in s do
  begin
    if c = delim then
    begin
      Split[currentNumber] := Split[currentNumber] * sign;
      currentNumber := currentNumber + 1;
      sign := 1;
    end
    else if c = '-' then
    begin
      sign := -1;
    end
    else
    begin
      Split[currentNumber] := Split[currentNumber]*10 + (ord(c)-ord('0'));
    end;
  end;
  Split[currentNumber] := Split[currentNumber] * sign;
end;

function RunProgram(var prog: IntCodeProgram; input: Int64): Int64;
var
  opcode: Int64;
  m1: Int64;
  m2: Int64;
  m3: Int64;
  i1: Int64;
  i2: Int64;
  i3: Int64;
  usedInput: Boolean;
begin
  usedInput := false;
  while prog.ip < Length(prog.mem) do
  begin
    opcode := prog.mem[prog.ip] mod 100;
    case opcode of
      1:
      begin
        // add
        m1 := prog.mem[prog.ip] div 100 mod 10;
        m2 := prog.mem[prog.ip] div 1000 mod 10;
        m3 := prog.mem[prog.ip] div 10000 mod 10;
        if m1 = 0 then i1 := prog.mem[prog.ip+1] else i1 := prog.ip+1;
        if m2 = 0 then i2 := prog.mem[prog.ip+2] else i2 := prog.ip+2;
        if m3 = 0 then i3 := prog.mem[prog.ip+3] else i3 := prog.ip+3;
        prog.mem[i3] := prog.mem[i1] + prog.mem[i2];
        prog.ip := prog.ip+4;
      end;
      2:
      begin
        // multiply
        m1 := prog.mem[prog.ip] div 100 mod 10;
        m2 := prog.mem[prog.ip] div 1000 mod 10;
        m3 := prog.mem[prog.ip] div 10000 mod 10;
        if m1 = 0 then i1 := prog.mem[prog.ip+1] else i1 := prog.ip+1;
        if m2 = 0 then i2 := prog.mem[prog.ip+2] else i2 := prog.ip+2;
        if m3 = 0 then i3 := prog.mem[prog.ip+3] else i3 := prog.ip+3;
        prog.mem[i3] := prog.mem[i1] * prog.mem[i2];
        prog.ip := prog.ip+4;
      end;
      3:
      begin
        // input
        if usedInput then break;
        m1 := prog.mem[prog.ip] div 100 mod 10;
        if m1 = 0 then i1 := prog.mem[prog.ip+1] else i1 := prog.ip+1;
        prog.mem[i1] := input;
        usedInput := true;
        prog.ip := prog.ip+2;
      end;
      4:
      begin
        // output
        m1 := prog.mem[prog.ip] div 100 mod 10;
        if m1 = 0 then i1 := prog.mem[prog.ip+1] else i1 := prog.ip+1;
        prog.ip := prog.ip + 2;
        Exit(prog.mem[i1]);
      end;
      5:
      begin
        // jump if true
        m1 := prog.mem[prog.ip] div 100 mod 10;
        m2 := prog.mem[prog.ip] div 1000 mod 10;
        if m1 = 0 then i1 := prog.mem[prog.ip+1] else i1 := prog.ip+1;
        if m2 = 0 then i2 := prog.mem[prog.ip+2] else i2 := prog.ip+2;
        if prog.mem[i1] <> 0 then prog.ip := prog.mem[i2] else prog.ip := prog.ip + 3;
      end;
      6:
      begin
        // jump if false
        m1 := prog.mem[prog.ip] div 100 mod 10;
        m2 := prog.mem[prog.ip] div 1000 mod 10;
        if m1 = 0 then i1 := prog.mem[prog.ip+1] else i1 := prog.ip+1;
        if m2 = 0 then i2 := prog.mem[prog.ip+2] else i2 := prog.ip+2;
        if prog.mem[i1] = 0 then prog.ip := prog.mem[i2] else prog.ip := prog.ip + 3;
      end;
      7:
      begin
        // less than
        m1 := prog.mem[prog.ip] div 100 mod 10;
        m2 := prog.mem[prog.ip] div 1000 mod 10;
        m3 := prog.mem[prog.ip] div 10000 mod 10;
        if m1 = 0 then i1 := prog.mem[prog.ip+1] else i1 := prog.ip+1;
        if m2 = 0 then i2 := prog.mem[prog.ip+2] else i2 := prog.ip+2;
        if m3 = 0 then i3 := prog.mem[prog.ip+3] else i3 := prog.ip+3;
        if prog.mem[i1] < prog.mem[i2] then prog.mem[i3] := 1 else prog.mem[i3] := 0;
        prog.ip := prog.ip+4;
      end;
      8:
      begin
        // equals
        m1 := prog.mem[prog.ip] div 100 mod 10;
        m2 := prog.mem[prog.ip] div 1000 mod 10;
        m3 := prog.mem[prog.ip] div 10000 mod 10;
        if m1 = 0 then i1 := prog.mem[prog.ip+1] else i1 := prog.ip+1;
        if m2 = 0 then i2 := prog.mem[prog.ip+2] else i2 := prog.ip+2;
        if m3 = 0 then i3 := prog.mem[prog.ip+3] else i3 := prog.ip+3;
        if prog.mem[i1] = prog.mem[i2] then prog.mem[i3] := 1 else prog.mem[i3] := 0;
        prog.ip := prog.ip+4;
      end;
      99:
      begin
        prog.halted := true;
        break;
      end;
      else
      begin
        write('[stderr] Unrecognized opcode ');
        writeln(opcode);
        break;
      end;
    end;
  end;
  // write('[stderr] Out of bounds (prog.ip = ');
  // write(prog.ip);
  // writeln(')');
  // Exit(stdout);
end;

function GeneratePermutations(values: IntArray; k: Int64): IntArray2d;
var
  i: Int64;
  t: Int64;
  result: IntArray2d;
  resultLength: Int64;
  subResult: IntArray2d;
  x: IntArray;
begin
  if k = Length(values)-1 then
  begin
    setLength(result, 1);
    result[0] := Copy(values, 0, Length(values));
    Exit(result);
  end;
  resultLength := 0;
  for i := k to Length(values)-1 do
  begin
    // generate permutations
    t := values[k];
    values[k] := values[i];
    values[i] := t;
    subResult := GeneratePermutations(values, k+1);
    t := values[k];
    values[k] := values[i];
    values[i] := t;

    // aggregate the results
    for x in subResult do
    begin
      setLength(result, resultLength+1);
      result[resultLength] := x;
      resultLength := resultLength+1;
    end;
  end;
  Exit(result);
end;

function RunAmps(mem: IntArray; perm: IntArray): Int64;
var
  output: Int64;
  p: Int64;
  prog: IntCodeProgram;
begin
  output := 0;
  for p in perm do
  begin
    prog := CreateProgram(Copy(mem, 0, Length(mem)));
    RunProgram(prog, p);
    output := RunProgram(prog, output);
  end;
  RunAmps := output;
end;

function RunAmpsWithFeedbackLoop(mem: IntArray; perm: IntArray): Int64;
var
  i: Int64;
  n: Int64;
  output: Int64;
  programs: array of IntCodeProgram;
begin
  n := Length(perm);
  output := 0;
  setLength(programs, n);
  for i := 0 to n-1 do
  begin
    programs[i] := CreateProgram(Copy(mem, 0, Length(mem)));
    RunProgram(programs[i], perm[i]);
  end;
  i := 0;
  while not programs[n-1].halted do
  begin
    output := RunProgram(programs[i], output);
    i := (i+1) mod n;
  end;
  Exit(output);
end;

// Main
var
  input: string;
  prog: IntArray;
  permutations: IntArray2d;
  p: IntArray;
  i: Int64;
  resultSignal: Int64;
  maxSignal1: Int64;
  maxSignal2: Int64;
begin
  maxSignal1 := 0;
  maxSignal2 := 0;
  readln(input);
  prog := Split(input, ',');
  setLength(p, 5);
  for i := 0 to 4 do
    p[i] := i;
  permutations := GeneratePermutations(p, 0);
  for p in permutations do
    begin
      resultSignal := RunAmps(prog, p);
      if resultSignal > maxSignal1 then
        maxSignal1 := resultSignal;
    end;
  write('Part 1: ');
  writeln(maxSignal1);

  for i := 0 to 4 do
    p[i] := i+5;
  permutations := GeneratePermutations(p, 0);
  for p in permutations do
  begin
    resultSignal := RunAmpsWithFeedbackLoop(prog, p);
    if resultSignal > maxSignal2 then
    begin
      maxSignal2 := resultSignal;
    end;
  end;
  write('Part 2: ');
  writeln(maxSignal2);
end.