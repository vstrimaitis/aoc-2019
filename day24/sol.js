const fs = require("fs");

const readFile = fileName =>
    new Promise((resolve, reject) =>
        fs.readFile(fileName, "utf8", (err, data) => {
            if (err) reject(err);
            else resolve(data);
        })
    );

const getNeighs = (board, i, j) => [
    i - 1 >= 0 ? board[i - 1][j] : ".",
    i + 1 < board.length ? board[i + 1][j] : ".",
    j - 1 >= 0 ? board[i][j - 1] : ".",
    j + 1 < board[i].length ? board[i][j + 1] : "."
];

const iterate = board => {
    const newBoard = board.map(r => [...r]);
    const n = board.length;
    const m = board[0].length;
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < m; j++) {
            const neighs = getNeighs(board, i, j);
            const numBugs = neighs.filter(c => c === "#").length;
            if (board[i][j] === "#" && numBugs !== 1) {
                newBoard[i][j] = ".";
            } else if (board[i][j] === "." && 1 <= numBugs && numBugs <= 2) {
                newBoard[i][j] = "#";
            }
        }
    }
    return newBoard;
};

const boardToString = board => board.map(r => r.join("")).join("\n");

const calcRating = board => {
    const n = board.length;
    const m = board[0].length;
    let val = 1;
    let result = 0;
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < m; j++) {
            if (board[i][j] === "#") {
                result += val;
            }
            val *= 2;
        }
    }
    return result;
};
const solve1 = async fileName => {
    const contents = await readFile(fileName);
    const lines = contents.split("\n").map(l => l.split(""));
    const seen = new Set();
    let state = lines;
    while (!seen.has(boardToString(state))) {
        seen.add(boardToString(state));
        state = iterate(state);
    }
    // console.log(boardToString(state));
    console.log("Part 1: ", calcRating(state));
};

const emptyStateFrom = s => s.map(r => r.map(c => "."));

const isEmpty = s => s.every(r => r.every(c => c === "."));

const getNeighsRecursive = (board, i, j, inner, outer) => {
    if (i === 2 && j === 2) return board;
    const neighs = [];

    if (i - 1 >= 0) {
        if (j === 2 && i - 1 === 2 && inner) {
            for (const x of inner[inner.length - 1]) {
                neighs.push(x);
            }
        } else {
            neighs.push(board[i - 1][j]);
        }
    } else if (outer) {
        neighs.push(outer[1][2]);
    }

    if (i + 1 < board.length) {
        if (j === 2 && i + 1 === 2 && inner) {
            for (const x of inner[0]) {
                neighs.push(x);
            }
        } else {
            neighs.push(board[i + 1][j]);
        }
    } else if (outer) {
        neighs.push(outer[3][2]);
    }

    if (j - 1 >= 0) {
        if (i === 2 && j - 1 === 2 && inner) {
            for (let ii = 0; ii < board.length; ii++) {
                neighs.push(inner[ii][inner[ii].length - 1]);
            }
        } else {
            neighs.push(board[i][j - 1]);
        }
    } else if (outer) {
        neighs.push(outer[2][1]);
    }

    if (j + 1 < board[i].length) {
        if (i === 2 && j + 1 === 2 && inner) {
            for (let ii = 0; ii < board.length; ii++) {
                neighs.push(inner[ii][0]);
            }
        } else {
            neighs.push(board[i][j + 1]);
        }
    } else if (outer) {
        neighs.push(outer[2][3]);
    }

    return neighs;
};

const iterateSingle = (board, inner, outer) => {
    const newBoard = board.map(r => [...r]);
    const n = board.length;
    const m = board[0].length;
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < m; j++) {
            const neighs = getNeighsRecursive(board, i, j, inner, outer);
            const numBugs = neighs.filter(c => c === "#").length;
            if (board[i][j] === "#" && numBugs !== 1) {
                newBoard[i][j] = ".";
            } else if (board[i][j] === "." && 1 <= numBugs && numBugs <= 2) {
                newBoard[i][j] = "#";
            }
        }
    }
    return newBoard;
};

const iterateRecursive = state => {
    const newState = { ...state };
    const indices = Object.keys(state).sort((a, b) => a - b);
    const tmpStart = indices[0] - 1;
    const tmpEnd = indices[indices.length - 1] - 0 + 1;
    for (let i = tmpStart; i <= tmpEnd; i++) {
        newState[i] = iterateSingle(
            state[i] || emptyStateFrom(state[0]),
            i === tmpEnd ? undefined : state[i + 1] || emptyStateFrom(state[0]),
            i === tmpStart
                ? undefined
                : state[i - 1] || emptyStateFrom(state[0])
        );
    }
    if (isEmpty(newState[tmpStart])) {
        delete newState[tmpStart];
    }
    if (isEmpty(newState[tmpEnd])) {
        delete newState[tmpEnd];
    }
    return newState;
};

const stateToString = state =>
    Object.keys(state)
        .sort((a, b) => a - b)
        .map(level => `Level ${level}:\n${boardToString(state[level])}`)
        .join("\n");

const countBugs = state =>
    Object.keys(state)
        .map(level => state[level])
        .map(brd =>
            brd.reduce((acc, r) => acc + r.filter(c => c === "#").length, 0)
        )
        .reduce((a, b) => a + b);
const solve2 = async fileName => {
    const contents = await readFile(fileName);
    const lines = contents.split("\n").map(l => l.split(""));
    let state = [lines];
    for (let i = 0; i < 200; i++) {
        // console.log(state);
        state = iterateRecursive(state);
    }
    // console.log(stateToString(state));
    console.log("Part 2: ", countBugs(state));
};

solve1("in");
solve2("in");
