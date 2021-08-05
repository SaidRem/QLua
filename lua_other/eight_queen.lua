-- The eight queen puzzle is the problem of placing eight chess queen
-- on a 8x8 chessboard so that no two queen threaten each other.
-- The solution provides that no two queens share the same row, column,
-- or diagonal. Thus, the puzzle is solved.

N = 8  -- board size

-- check whether position (n, c) is free from attacks
function isplaceok(a, n, c)
    for i = 1, n - 1 do  -- for each queen already placed
        if (a[i] == c) or  -- same column?
           (a[i] - i == c - n) or  -- same diagonal?
           (a[i] + i == c + n) then  -- same diagonal?
            return false  -- place can be attacked
        end
    end
    return true  -- no attacks; place is OK
end

-- print a board
function printsolution(a)
    for i = 1, N do  -- for each row
        for j = 1, N do  -- and for each column
            -- write "X" or "-" plus a space
            io.write(a[i] == j and "X" or "-", " ")
        end
        io.write("\n")
    end
    io.write("\n")
end

-- add to board 'a' all queens from 'n' to 'N'
function addqueen(a, n)
    if n > N then  -- all queens have benn placed?
        printsolution(a)
    else  -- try to place n-th queen
        for c = 1, N do
            if isplaceok(a, n, c) then
                a[n] = c  -- place n-th queen at column 'c'
                addqueen(a, n + 1)
            end
        end
    end
end

-- run the program
addqueen({}, 1)
io.read()
