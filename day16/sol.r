build_pattern <- function(i, len) {
    pattern <- c(rep(0,i), rep(1,i), rep(0,i), rep(-1,i))
    pattern <- rep(pattern, length.out=len+1)
    return(pattern[-1])
}

iterate <- function(list, times) {
    n <- length(list)
    new_list <- rep(0, n)
    for (it in 1:times) {
        print(paste0("iteration #",it))
        for (i in 1:n) {
            new_list[i] <- 0
            p <- build_pattern(i, n)
            for (j in 1:n) {
                new_list[i] = new_list[i] + list[j] * p[j]
            }
            if (new_list[i] < 0) {
                new_list[i] = new_list[i] * -1
            }
            new_list[i] = new_list[i] %% 10
        }
        for (i in 1:n) {
            list[i] <- new_list[i]
        }
    }
    return(new_list)
}

part1 <- function(inputFile, numIterations, digitsToTake) {
    data <- scan(inputFile, what=character())
    data <- as.numeric(strsplit(data, "")[[1]])
    data <- iterate(data, numIterations)
    return(paste(data[1:digitsToTake], collapse=""))
}

calculate <- function(startData, numIterations, offset) {
    total_len <- length(startData)*10000
    suffix_len <- total_len - offset
    data <- rep(startData, length.out=total_len)[(offset+1):total_len]
    for (it in 1:numIterations) {
        print(paste0("iteration #",it))
        s <- sum(data)
        for (i in 1:suffix_len) {
            ss <- s - data[i]
            data[i] <- s
            data[i] <- data[i] %% 10
            s <- ss
        }
    }
    return(data)
}

part2 <- function(inputFile, numIterations, digitsToTake) {
    data <- scan(inputFile, what=character())
    data <- as.numeric(strsplit(data, "")[[1]])
    offset <- as.numeric(paste(data[1:7], collapse=""))
    return(paste(calculate(data, numIterations, offset)[1:digitsToTake], collapse=""))

}

print(paste0("Part 1: ", part1("in", 100, 8)))
print(paste0("Part 2: ", part2("in", 100, 8)))
