mapping(string:array(string)) read() {
    mapping(string:array(string)) adj = ([]);
    while(true) {
        string line = Stdio.stdin->gets();
        if (line == "") {
            break;
        }
        array(string) parts = line / ")";
        if (sizeof(parts) != 2) {
            throw ("Invalid input");
        }
        string u = parts[0];
        string v = parts[1];
        adj[u] += ({v});
        adj[v] += ({u});
    }
    return adj;
}

void debug(mapping(string:array(string)) adj) {
    string u;
    foreach(indices(adj), u) {
        write(u);
        write(": ");
        string v;
        foreach(adj[u], v) {
            write(v);
            write(", ");
        }
        write("\n");
    }
}

int dfs1(mapping(string:array(string)) adj, string u, string prev, int depth) {
    int ans = depth;
    string v;
    foreach(adj[u], v) {
        if (v != prev) {
            ans += dfs1(adj, v, u, depth+1);
        }
    }
    return ans;
}

int dfs2(mapping(string:array(string)) adj, string u, string prev, string goal, int depth) {
    if (u == goal) {
        return depth-2;
    }
    string v;
    foreach(adj[u], v) {
        if (v != prev) {
            int subans = dfs2(adj, v, u, goal, depth+1);
            if (subans != 0) return subans;
        }
    }
    return 0;
}

int main()
{
    mapping(string:array(string)) adj = read();
    write("Part 1: ");
    Stdio.stdout->printf("%d\n", dfs1(adj, "COM", "", 0));
    write("\n");
    write("Part 2: ");
    Stdio.stdout->printf("%d\n", dfs2(adj, "YOU", "", "SAN", 0));
    write("\n");
    return 0;
}
