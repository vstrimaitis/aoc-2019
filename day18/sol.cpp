#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
typedef unsigned long long ull;
typedef long double ld;
typedef pair<int, int> pii;
typedef pair<ll, ll> pll;
typedef pair<double, double> pdd;
template <typename T> using min_heap = priority_queue<T, vector<T>, greater<T>>;
template <typename T> using max_heap = priority_queue<T, vector<T>, less<T>>;

template<typename A, typename B> ostream& operator<<(ostream& out, pair<A, B> p) { out << "(" << p.first << ", " << p.second << ")"; return out;}
template<typename T> ostream& operator<<(ostream& out, vector<T> v) { out << "["; for(auto& x : v) out << x << ", "; out << "]";return out;}
template<typename T> ostream& operator<<(ostream& out, deque<T> v) { out << "["; for(auto& x : v) out << x << ", "; out << "]";return out;}
template<typename T> ostream& operator<<(ostream& out, set<T> v) { out << "{"; for(auto& x : v) out << x << ", "; out << "}"; return out; }
template<typename K, typename V> ostream& operator<<(ostream& out, map<K, V> m) { out << "{"; for(auto& e : m) out << e.first << " -> " << e.second << ", "; out << "}"; return out; }

#define FAST_IO ios_base::sync_with_stdio(false); cin.tie(nullptr)
#define TESTS(t) int NUMBER_OF_TESTS; cin >> NUMBER_OF_TESTS; for(int t = 1; t <= NUMBER_OF_TESTS; t++)
#define FOR(i, begin, end) for (int i = (begin); i < (end); i++)
#define sgn(a)     ((a) > eps ? 1 : ((a) < -eps ? -1 : 0))
#define precise(x) fixed << setprecision(x)
#define all(a) a.begin(), a.end()
#define pb push_back
#define rnd(a, b) (uniform_int_distribution<int>((a), (b))(rng))
#ifndef LOCAL
    #define cerr if(0)cout
    #ifndef INTERACTIVE
        #define endl "\n"
    #endif
    #define debug(args...) if(0){}
#else
    #define debug(args...) { string _s = #args; replace(_s.begin(), _s.end(), ',', ' '); stringstream _ss(_s); istream_iterator<string> _it(_ss); dbg(_it, true, args); }
    void dbg(istream_iterator<string> it, bool isStart) {cerr << "</debug>" << endl;}
    template<typename T, typename... Args>
    void dbg(istream_iterator<string> it, bool isStart, T a, Args... args) {
        if(isStart) cerr << "<debug>" << endl;
        cerr << "  " << *it << " = " << a << endl;
        dbg(++it, false, args...);
    }
#endif
mt19937 rng(chrono::steady_clock::now().time_since_epoch().count());
std::chrono::steady_clock::time_point __clock__;
void startTime() {__clock__ = std::chrono::steady_clock::now();}
ld getTime() {
    auto end = std::chrono::steady_clock::now();
    auto t = std::chrono::duration_cast<std::chrono::microseconds> (end-__clock__).count();
    return ld(t)/1e6;
}
void timeit(string msg) {
    cerr << "> " << msg << ": " << precise(6) << getTime() << endl;
}
template<typename T> inline bool maxi(T& a, T b) { return b > a ? (a = b, true) : false; }
template<typename T> inline bool mini(T& a, T b) { return b < a ? (a = b, true) : false; }
const ld PI = asin(1) * 2;
const ld eps = 1e-6;
const int oo = 2e9;
const ll OO = 2e18;
const ll MOD = 1000000007;
const int MAXN = 200000;

struct Edge {
    char to;
    int w;
    int mask;
};
ostream& operator<<(ostream& out, Edge e) {
    string needs = "";
    for(char c = 'a'; c <= 'z'; c++) {
        int id = c-'a';
        if (e.mask&(1<<id)) {
            needs.pb(c);
        }
    }
    return out << "(to=" << e.to << ", w=" << e.w << ", mask=" << needs << ")";
}

pii findStart(vector<string>& board) {
    int n = board.size();
    int m = board[0].size();
    FOR(i, 0, n) {
        FOR(j, 0, m) {
            if(board[i][j] == '@')
                return {i, j};
        }
    }
    return {-1, -1};
}

vector<pii> getKeys(vector<string>& board) {
    int n = board.size();
    int m = board[0].size();
    vector<pii> res;
    FOR(i, 0, n)
    {
        FOR(j, 0, m) {
            if('a' <= board[i][j] && board[i][j] <= 'z') {
                res.pb({i, j});
            }
        }
    }
    return res;
}

void visit(queue<pii>& Q, vector<string>& board, map<pii, pair<int, int>>& paths, int i, int j, pii u) {
    int n = board.size();
    int m = board[0].size();
    if(i >= 0 && i < n && j >= 0 && j < m && board[i][j] != '#' && paths.count({i, j}) == 0) {
        auto newD = paths[u].first+1;
        auto newPath = paths[u].second;
        if (board[i][j] >= 'A' && board[i][j] <= 'Z') {
            int id = tolower(board[i][j]) - 'a';
            newPath |= (1<<id);
        }
        Q.push({i, j});
        paths[{i, j}] = {newD, newPath};
    }
}

map<char, pair<int, int>> bfs1(vector<string>& board, pii start) {
    map<pii, pair<int, int>> paths;
    queue<pii> Q;
    Q.push(start);
    paths[start] = {0, 0};
    while(!Q.empty()) {
        auto u = Q.front();
        Q.pop();
        int i = u.first;
        int j = u.second;
        visit(Q, board, paths, i - 1, j, u);
        visit(Q, board, paths, i + 1, j, u);
        visit(Q, board, paths, i, j - 1, u);
        visit(Q, board, paths, i, j + 1, u);
    }

    map<char, pair<int, int>> res;
    for(auto& e : paths) {
        char c = board[e.first.first][e.first.second];
        if(('a' <= c && c <= 'z') || ('0' <= c && c <= '9')) {
            res[c] = e.second;
        }
    }
    return res;
}

int dijkstra(map<char, vector<Edge>>& adj, vector<char> starts) {
    int allLetters = 0;
    for(auto e : adj) {
        if('a' <= e.first && e.first <= 'z') {
            int id = e.first-'a';
            allLetters |= (1<<id);
        }
    }
    min_heap<pair<pair<int, string>, int>> Q;
    map<pair<string, int>, int> dists;
    string startChars = "";
    for(char c : starts)
        startChars.pb(c);
    Q.push({{0, startChars}, 0});
    dists[{startChars,0}] = 0;

    while(!Q.empty()) {
        auto t = Q.top(); Q.pop();
        int d = t.first.first;
        string cs = t.first.second;
        int mask = t.second;
        if (mask == allLetters)
        {
            return d;
        }
        FOR(i, 0, (int)cs.size()) {
            char c = cs[i];
            for(auto& e : adj[c]) {
                if ((mask&e.mask) != e.mask) {
                    continue;
                }
                int id = 'a' <= e.to && e.to <= 'z' ? e.to-'a' : -1;
                int newMask = id == -1 ? mask : (mask | (1 << id));
                int newD = d + e.w;
                auto newChars = cs;
                newChars[i] = e.to;
                pair<string, int> newState = {newChars, newMask};
                if (dists.count(newState) == 0 || newD < dists[newState]) {
                    dists[newState] = newD;
                    Q.push({{newD, newChars}, newMask});
                }
            }
        }
    }
    return -1;
}

int solve1(vector<string> board) {
    auto start = findStart(board);
    board[start.first][start.second] = '1';
    auto keys = getKeys(board);
    map<char, vector<Edge>> adj;
    for(auto& e : bfs1(board, start)) {
        if (e.first == '1')
            continue;
        adj['1'].pb({e.first, e.second.first, e.second.second});
    }
    for(auto k : keys) {
        auto u = board[k.first][k.second];
        for(auto& e : bfs1(board, k)) {
            if (e.first == u)
                continue;
            adj[u].pb({e.first, e.second.first, e.second.second});
        }
    }
    return dijkstra(adj, {'1'});
}

int solve2(vector<string> board) {
    auto start = findStart(board);
    board[start.first][start.second] = '#';
    board[start.first-1][start.second] = '#';
    board[start.first+1][start.second] = '#';
    board[start.first][start.second-1] = '#';
    board[start.first][start.second+1] = '#';
    board[start.first-1][start.second-1] = '1';
    board[start.first-1][start.second+1] = '2';
    board[start.first+1][start.second-1] = '3';
    board[start.first+1][start.second+1] = '4';

    vector<pii> starts = {
        {start.first-1, start.second-1},
        {start.first-1, start.second+1},
        {start.first+1, start.second-1},
        {start.first+1, start.second+1},
    };
    auto keys = getKeys(board);
    map<char, vector<Edge>> adj;

    for(auto start : starts) {
        char c = board[start.first][start.second];
        for(auto& e : bfs1(board, start)) {
            if (e.first == c)
                continue;
            adj[c].pb({e.first, e.second.first, e.second.second});
        }
    }
    for(auto k : keys) {
        auto u = board[k.first][k.second];
        for(auto& e : bfs1(board, k)) {
            if (e.first == u)
                continue;
            adj[u].pb({e.first, e.second.first, e.second.second});
        }
    }

    vector<char> startChars;
    for(auto start : starts) startChars.pb(board[start.first][start.second]);
    return dijkstra(adj, startChars);
}

int main()
{
    FAST_IO;
    startTime();
    
    string row;
    vector<string> board;
    while (cin >> row)
    {
        board.pb(row);
    }
    cout << "Part 1: " << solve1(board) << endl;
    cout << "Part 2: " << solve2(board) << endl;
    
    timeit("Finished");
    return 0;
}