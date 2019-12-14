module Main where

import System.Environment
import Flow
import Data.List (concatMap, map, filter, sort, reverse, (\\))
import Data.List.Index (indexed)
import Data.List.Unique (sortUniq)

parseLine :: Int -> String -> [(Int, Int)]
parseLine i row = row
    |> indexed
    |> filter (\(_, c) -> c == '#')
    |> map (\(j, _) -> (i, j))

parseInput :: String -> [(Int, Int)]
parseInput input = lines input
    |> indexed
    |> concatMap (uncurry parseLine)

slope :: (Int, Int) -> (Int, Int) -> (Int, Int)
slope (x1, y1) (x2, y2) =
    let dx = x2-x1
        dy = y2-y1
        g = gcd dx dy
    in (dx `div` g, dy `div` g)

countHits :: [(Int, Int)] -> (Int, Int) -> Int
countHits coords station = coords
    |> filter (/= station)
    |> map (slope station)
    |> sortUniq
    |> length

findBestLocation :: [(Int, Int)] -> (Int, Int)
findBestLocation coords = coords
    |> map (\c -> (countHits coords c, c))
    |> sort
    |> reverse
    |> \l -> head l
    |> snd


solve1 :: [(Int, Int)] -> Int
solve1 coords = coords
    |> findBestLocation
    |> countHits coords

angle :: Int -> Int -> Double
angle i j =
    let x = fromIntegral j
        y = - (fromIntegral i)
        a = atan2 y x
        b = (if a < 0 then -a else 2*pi-a) + pi/2
    in if b >= 2*pi then b-2*pi else b

angleBetween :: (Int, Int) -> (Int, Int) -> Double
angleBetween from to =
    let di = fst to - fst from
        dj = snd to - snd from
    in angle di dj

dist2 :: (Int, Int) -> (Int, Int) -> Double
dist2 (x1, y1) (x2, y2) =
    let dx = fromIntegral x2 - fromIntegral x1
        dy = fromIntegral y2 - fromIntegral y1
    in dx*dx+dy*dy

findClosest :: [(Int, Int)] -> (Int, Int) -> (Int, Int) -> Int
findClosest coords station s = coords
    |> indexed
    |> filter (\x -> station /= snd x)
    |> filter (\x -> slope station (snd x) == s)
    |> map (\(i, c) -> (dist2 station c, i))
    |> sort
    |> head
    |> snd

sortByLazor :: [(Int, Int)] -> (Int, Int) -> [(Int, Int)]
sortByLazor [] _ = []
sortByLazor [a] b = if a == b then [] else [a]
-- sortByLazor coords station = coords
--     |> filter (/= station)
--     |> map (slope station)
--     |> map (\(i, j) -> (angle i j, (i, j)))
--     |> sort
sortByLazor coords station =
    let slopes = coords
            |> filter (/= station)
            |> map (slope station)
        uniqueSlopes = sortUniq slopes
        idsToTake = uniqueSlopes |> map (findClosest coords station)
        idsToLeave = coords
            |> indexed
            |> map fst
            |> \x -> x \\ idsToTake
        coordsToTake = idsToTake
            |> map (\x -> coords !! x)
            |> map (\(i, j) -> (angleBetween station (i, j), (i, j)))
            |> sort
            |> map (\(_, (i, j)) -> (i, j))
        coordsToLeave = idsToLeave
            |> map (\x -> coords !! x)
            |> \x -> sortByLazor x station
    in coordsToTake ++ coordsToLeave

solve2 :: [(Int, Int)] -> Int
solve2 coords = coords
    |> findBestLocation
    |> sortByLazor coords
    |> \c -> c !! 199
    |> \(y, x) -> 100*x+y

main = do
    args <- getArgs
    content <- readFile $ head args
    let input = parseInput content
    putStrLn "Parsed input:"
    print input
    let ans1 = solve1 input
    let ans2 = solve2 input
    putStr "Part 1: "
    print ans1
    putStr "Part 2: "
    print ans2

