import java.io.*;
import java.util.*;

class IntCodeProgram {
    private final Process p;
    private final BufferedReader stdout;
    private final BufferedWriter stdin;
    private final boolean debug;

    public IntCodeProgram(String srcFile, boolean debug) throws IOException {
        this.debug = debug;
        p = Runtime.getRuntime().exec(String.format("./intc %s", srcFile));
        stdout = new BufferedReader(new InputStreamReader(p.getInputStream()));
        stdin = new BufferedWriter(new OutputStreamWriter(p.getOutputStream()));
    }

    public void writeln(int s) throws IOException {
        if(debug) System.out.println(String.format("[ in] %d", s));
        stdin.write(Integer.toString(s));
        stdin.write("\n");
        stdin.flush();
    }

    public int readln() throws IOException {
        int res = Integer.parseInt(stdout.readLine());
        if (debug) System.out.println(String.format("[out] %d", res));
        return res;
    }

}

public class Main {

    static Map<String, Integer> cellTypes;
    static Map<String, Integer> dists;
    static IntCodeProgram intc;

    public static void main(String[] args) throws IOException {
        System.out.println(String.format("Part 1: %d", solve1()));
        System.out.println(String.format("Part 2: %d", solve2()));
    }

    static int solve1() throws IOException {
        cellTypes = new HashMap<>();
        dists = new HashMap<>();
        intc = new IntCodeProgram("in", false);
        dfs(0, 0, 0);
        Integer ans1 = cellTypes.entrySet()
            .stream()
            .filter(e -> e.getValue() == 2)
            .map(e -> dists.get(e.getKey()))
            .findFirst()
            .orElse(null);
        return ans1;
    }

    static int solve2() throws IOException {
        solve1();
        Integer[] oxygen = cellTypes.entrySet()
            .stream()
            .filter(e -> e.getValue() == 2)
            .map(e -> decode(e.getKey()))
            .findFirst()
            .orElse(null);
        dists = new HashMap<>();
        dists.put(encode(oxygen[0], oxygen[1]), 0);
        dfs2(oxygen[0], oxygen[1], 0);
        return dists.entrySet()
            .stream()
            .map(e -> e.getValue())
            .max(Integer::compare)
            .get();
    }

    static void dfs(int i, int j, int d) throws IOException {
        if (dists.containsKey(encode(i, j))) return;
        dists.put(encode(i, j), d);
        for(int di = -1; di <= 1; di++) {
            for(int dj = -1; dj <= 1; dj++) {
                if(Math.abs(di)+Math.abs(dj) != 1) continue;
                int ii = i+di;
                int jj = j+dj;
                String key = encode(ii, jj);
                if(cellTypes.containsKey(key)) continue;
                int dir = getDir(di, dj);
                intc.writeln(dir);
                int type = intc.readln();
                if (type != 0) {
                    cellTypes.put(key, type);
                    dfs(ii, jj, d+1);
                    intc.writeln(reverseDir(dir));
                    intc.readln();
                }
            }
        }
    }

    static void dfs2(int i, int j, int d) throws IOException {
        dists.put(encode(i, j), d);
        for(int di = -1; di <= 1; di++) {
            for(int dj = -1; dj <= 1; dj++) {
                if(Math.abs(di)+Math.abs(dj) != 1) continue;
                int ii = i+di;
                int jj = j+dj;
                String key = encode(ii, jj);
                if(dists.containsKey(key) || !cellTypes.containsKey(key) || cellTypes.get(key) == 0) continue;
                dfs2(ii, jj, d+1);
            }
        }
    }

    static int getDir(int di, int dj) {
        if (di == -1 && dj == 0) return 1;
        if (di == 1 && dj == 0) return 2;
        if (di == 0 && dj == 1) return 3;
        return 4;
    }

    static int reverseDir(int d) {
        if (d == 1) return 2;
        if (d == 2) return 1;
        if (d == 3) return 4;
        return 3;
    }

    static String encode(int i, int j) {
        return String.format("%d,%d", i, j);
    }

    static Integer[] decode(String s) {
        return Arrays.stream(s.split(",")).map(Integer::parseInt).toArray(Integer[]::new);
    }
}