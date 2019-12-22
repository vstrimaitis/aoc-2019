function read(file)
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

function isLetter(c)
    return string.byte(c) >= string.byte("A") and string.byte(c) <= string.byte("Z")
end

function getPortals(input)
    portals = {}
    for i=1,#input do
        for j=1,#input[i] do
            local c = input[i]:sub(j, j)
            if c == '.' then
                local portal = nil
                local type = nil
                if i-1 >= 1 and isLetter(input[i-1]:sub(j,j)) then
                    local c1 = input[i-2]:sub(j,j)
                    local c2 = input[i-1]:sub(j,j)
                    portal = c1 .. c2
                    type = i == 3 and -1 or 1
                elseif i+1 <= #input and isLetter(input[i+1]:sub(j,j)) then
                    local c1 = input[i+1]:sub(j,j)
                    local c2 = input[i+2]:sub(j,j)
                    portal = c1 .. c2
                    type = i == #input-2 and -1 or 1
                elseif j-1 >= 1 and isLetter(input[i]:sub(j-1,j-1)) then
                    local c1 = input[i]:sub(j-2,j-2)
                    local c2 = input[i]:sub(j-1,j-1)
                    portal = c1 .. c2
                    type = j == 3 and -1 or 1
                elseif j+1 <= #input[i] and isLetter(input[i]:sub(j+1,j+1)) then
                    local c1 = input[i]:sub(j+1,j+1)
                    local c2 = input[i]:sub(j+2,j+2)
                    portal = c1 .. c2
                    type = j == #input[i]-2 and -1 or 1
                end

                if portal ~= nil then
                    if portals[portal] == nil then
                        portals[portal] = {}
                    end
                    portals[portal][#portals[portal]+1] = {i,j,type}
                end
            end
        end
    end
    return portals
end

function getBoard(input)
    local board = {}
    for i=1,#input do
        local row = {}
        for j=1,#input[i] do
            local c = input[i]:sub(j, j)
            if c == " " or isLetter(c) then
                c = "#"
            end
            row[#row+1] = c
        end
        board[#board+1] = row
    end
    return board
end

function encode(coord, n)
    local res = ""
    for i=1,n do
        res = res .. coord[i]
        if i ~= n then
            res = res .. ","
        end
    end
    return res
end

function decode(s)
    local parts = {}
    for p in string.gmatch(s, "%d+") do
        parts[#parts+1] = tonumber(p)
    end
    return parts
end

function bfs(from, to, board, portals, go_deep)
    local inspect = require("inspect")
    local Queue = require("queue")
    local Q = Queue.new()
    local dist = {}

    Queue.push(Q, from)
    dist[encode(from, 3)] = 0
    while Q[Q.first] ~= nil do
        local u = Queue.pop(Q)
        local u_enc = encode(u, 3)
        local u_enc_short = encode(u, 2)
        local i = u[1]
        local j = u[2]
        local k = u[3]
        local d = dist[u_enc]
        if u_enc == encode(to, 3) then
            return d
        end
        local neighs = {
            {i-1, j, k},
            {i+1, j, k},
            {i, j-1, k},
            {i, j+1, k}
        }
        if portals[u_enc_short] ~= nil then
            local t = -portals[u_enc_short][3]
            if not go_deep then
                t = 0
            end
            neighs[#neighs+1] = {portals[u_enc_short][1], portals[u_enc_short][2], k+t}
        end
        local real_neighs = {}
        for k,v in pairs(neighs) do
            local ii = v[1]
            local jj = v[2]
            local kk = v[3]
            local v_enc = encode(v, 3)
            if ii >= 1 and ii <= #board and jj >= 1 and jj <= #board[ii] and kk >= 0 and dist[v_enc] == nil and board[ii][jj] == "." then
                Queue.push(Q, v)
                dist[v_enc] = d+1
                real_neighs[#real_neighs+1] = v
            end
        end
        -- print(u_enc)
        -- print(inspect(real_neighs))
    end
    return -1
end

function solve(inputFile, go_deep)
    local inspect = require("inspect")
    input = read(inputFile)
    portals = getPortals(input)
    board = getBoard(input)
    -- print(inspect(board))
    -- print(inspect(portals))
    start = portals["AA"][1]
    goal = portals["ZZ"][1]
    start[3] = 0
    goal[3] = 0
    portalPairs = {}
    for k,v in pairs(portals) do
        if k ~= "AA" and k ~= "ZZ" then
            local i = #portalPairs+1
            portalPairs[encode(v[1],2)] = v[2]
            portalPairs[encode(v[2],2)] = v[1]
        end
    end
    -- print(inspect(portalPairs))
    print(string.format("Answer: %d", bfs(start, goal, board, portalPairs, go_deep)))
end

solve("in", false)
solve("in", true)