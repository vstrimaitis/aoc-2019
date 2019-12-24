import 'dart:io';
import 'dart:convert';

/*
* Deal into new stack == reverse
* cut N == rotate left by N
* deal with increment N == fancy
*/

List<int> dealIntoNewStack(List<int> l) {
  return l.reversed.toList();
}

List<int> cut(List<int> l, int n) {
  n = n % l.length;
  return l.sublist(n)..addAll(l.sublist(0, n));
}

List<int> dealWithIncrement(List<int> l, int n) {
  final newList = new List<int>(l.length);
  var i = 0;
  l.forEach((x) {
    newList[i] = x;
    i = (i+n)%l.length;
  });
  return newList;
}

void solve1(String inputFile, int N, int cardToFind) async {
  final input = await new File(inputFile).readAsString();
  final lines = input.split("\n");
  var cards = new List<int>.generate(N, (i) => i);
  lines.forEach((cmd) {
    if (cmd == "deal into new stack") {
      cards = dealIntoNewStack(cards);
    } else if(cmd.startsWith("cut")) {
      final parts = cmd.split(" ");
      cards = cut(cards, int.parse(parts[parts.length-1]));
    } else if(cmd.startsWith("deal with increment")) {
      final parts = cmd.split(" ");
      cards = dealWithIncrement(cards, int.parse(parts[parts.length-1]));
    }
  });
  print("Part 1: ${cards.indexOf(cardToFind)}");
}

int pwr(int a, int e, int m) {
  if (e == 0) return 1;
  if (e%2 == 1) return a*pwr(a, e-1, m) % m;
  var h = pwr(a, e~/2, m);
  return h*h%m;
}

void solve2(String inputFile, int N, int times, int positionToFind) async {
  final input = await new File(inputFile).readAsString();
  final lines = input.split("\n");
  var a = 1;
  var b = 0;
  lines.forEach((cmd) {
    if (cmd == "deal into new stack") {
      var newA = (-a)%N;
      var newB = (N-1-b)%N;
      a = newA;
      b = newB;
    } else if(cmd.startsWith("cut")) {
      final parts = cmd.split(" ");
      var x = int.parse(parts[parts.length-1]);
      b = (b-x)%N;
    } else if(cmd.startsWith("deal with increment")) {
      final parts = cmd.split(" ");
      var x = int.parse(parts[parts.length-1]);
      var newA = a*x%N;
      var newB = b*x%N;
      a = newA;
      b = newB;
    }
  });
  var off = BigInt.from(b);
  off *= BigInt.from(1-a).modPow(BigInt.from(N-2), BigInt.from(N));
  off %= BigInt.from(N);
  var big = BigInt.from(positionToFind-off.toInt());
  big *= BigInt.from(a).modPow(BigInt.from(times)*BigInt.from(N-2), BigInt.from(N));
  big += off;
  big %= BigInt.from(N);
  var card = big.toInt();
  print("Part 2: $card");
}

void main() async {
  await solve1("in", 10007, 2019);
  await solve2("in", 119315717514047, 101741582076661, 2020);
}
