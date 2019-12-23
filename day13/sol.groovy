def countBlocks(board) {
    def n = board.length
    def m = board[0].length
    def ans = 0
    for (i = 0; i < n; i++) {
        for(j = 0; j < m; j++) {
            if(board[i][j] == 2) {
                ans++
            }
        }
    }
    return ans
}

def getAllOutput(sourceFile) {
    p = new ProcessBuilder("./intc", sourceFile).start()
    stdout = new BufferedReader(new InputStreamReader(p.getInputStream()))
    def lines = []
    while((line = stdout.readLine()) != null) {
        lines.add(line)
    }
    return lines
}

def buildBoard(lines) {
    def minX = lines[0].toInteger()
    def maxX = minX
    def minY = lines[1].toInteger()
    def maxY = minY
    for (i = 0; i < lines.size; i += 3) {
        def x = lines[i].toInteger()
        minX = Math.min(minX, x)
        maxX = Math.max(maxX, x)
    }
    for (i = 1; i < lines.size; i += 3) {
        def y = lines[i].toInteger()
        minY = Math.min(minY, y)
        maxY = Math.max(maxY, y)
    }
    def board = new Integer[maxY-minY+1][maxX-minX+1]
    for (i = 0; i < lines.size; i += 3) {
        def x = lines[i].toInteger()
        def y = lines[i+1].toInteger()
        def t = lines[i+2].toInteger()
        board[y][x] = t
    }
    return board
}

def solve1() {
    def lines = getAllOutput("in")
    def board = buildBoard(lines)
    print("Part 1: ")
    println(countBlocks(board))
}

def drawBoard(board) {
    def n = board.length
    def m = board[0].length
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++) {
            def c = " "
            def t = board[i][j]
            if (t == 0) {
                c = " "
            } else if(t == 1) {
                c = "#"
            } else if(t == 2) {
                c = "*"
            } else if(t == 3) {
                c = "="
            } else {
                c = "o"
            }
            print(c)
        }
        println()
    }
}

def clearScreen(board) {
    def cnt = board.length*board[0].length
    while(cnt > 0) {
        cnt--
        print("\b")
    }
}

def solve2() {
    def board = buildBoard(getAllOutput("in"))
    drawBoard(board)
    def score = 0
    def leftToSkip = board.length*board[0].length
    def ballPos = null
    def paddlePos = null
    for (i = 0; i < board.length; i++) {
        for (j = 0; j < board[i].length; j++) {
            if (board[i][j] == 4) {
                ballPos = [i, j]
            } else if(board[i][j] == 3) {
                paddlePos = [i, j]
            }
        }
    }

    builder = new ProcessBuilder("./intc", "in2")
    // builder.redirectErrorStream(true)
    p = builder.start()
    stderr = new Scanner(p.getErrorStream())
    Thread.start({
        while(stderr.hasNextLine()) {
            line = stderr.nextLine()
            printf("[stderr] %s\n", line)
        }
    })
    stdout = new Scanner(p.getInputStream())
    Thread.start({
        def tile = []
        while (stdout.hasNextLine()) {
            line = stdout.nextLine()
            // printf("! %s\n", line)
            tile.add(line.toInteger())
            if (tile.size == 3) {
                if (tile[2] == 4) {
                    ballPos = [tile[0], tile[1]]
                }
                if(tile[2] == 3) {
                    paddlePos = [tile[0], tile[1]]
                }
                
                if (tile[0] == -1 && tile[1] == 0) {
                    score = tile[2]
                } else {
                    board[tile[1]][tile[0]] = tile[2]
                }
                tile = []
            }
        }
    })

    stdin = new PrintWriter(p.getOutputStream())
    while(countBlocks(board) > 0) {
        Thread.sleep(100)
        def move = (int)Math.signum(ballPos[0] - paddlePos[0])
        // printf("{%d}", move)
        stdin.println(move)
        stdin.flush()
        printf("Score: %d, blocks left: %d\n", score, countBlocks(board))
        // drawBoard(board)
    }
    printf("Part 2: %d\n", score)
}

solve1()
solve2()
