<?php
    function getOutput($srcFile, $raw=false, $stdin=null) {
        $descriptors = array(
            0 => array("pipe", "r"),
            1 => array("pipe", "w"),
            2 => array("pipe", "w")
        );
        $proc = proc_open("./intc ".$srcFile." --ascii", $descriptors, $pipes);
        if (is_resource($proc)) {
            // sleep(1);
            if ($stdin != null) {
                fwrite($pipes[0], $stdin."\n");
                fflush($pipes[0]);
            }
            fclose($pipes[0]);
            $output = stream_get_contents($pipes[1]);
            fclose($pipes[1]);
            $lines = explode("\n", $output);
            if(!$raw) {
                for($i = 0; $i < count($lines); $i++) {
                    if(strlen($lines[$i]) != strlen($lines[0])) {
                        $lines[$i] = null;
                    }
                }
                $lines = array_filter($lines);
            }
            proc_close($proc);
            return $lines;
        }
        return null;
    }
    function solve1() {
        $lines = getOutput("in");
        $n = count($lines);
        $m = strlen($lines[0]);
        $ans = 0;
        for ($i = 1; $i < $n-1; $i++) {
            for($j = 1; $j < $m-1; $j++) {
                if ($lines[$i][$j] == "#" &&
                    $lines[$i-1][$j] == "#" &&
                    $lines[$i+1][$j] == "#" &&
                    $lines[$i][$j-1] == "#" &&
                    $lines[$i][$j+1] == "#") {
                        $ans += $i*$j;
                    }
            }
        }
        return $ans;
    }

    function getChar($lines, $i, $j, $dir) {
        if ($dir == "^") {
            if ($i == 0) return ".";
            return $lines[$i-1][$j];
        }
        if ($dir == "v") {
            if ($i+1 >= count($lines)) return ".";
            return $lines[$i+1][$j];
        }
        if ($dir == "<") {
            if ($j == 0) return ".";
            return $lines[$i][$j-1];
        }
        if ($dir == ">") {
            if ($j+1 >= strlen($lines[$i])) return ".";
            return $lines[$i][$j+1];
        }
    }

    function turn($dir, $turn) {
        if ($dir == "^") return $turn == "L" ? "<" : ">";
        if ($dir == ">") return $turn == "L" ? "^" : "v";
        if ($dir == "v") return $turn == "L" ? ">" : "<";
        if ($dir == "<") return $turn == "L" ? "v" : "^";
    }

    function move($i, $j, $d) {
        if ($d == "^") return array($i-1, $j);
        if ($d == "v") return array($i+1, $j);
        if ($d == "<") return array($i, $j-1);
        if ($d == ">") return array($i, $j+1);
    }

    function onlyLettersLeft($arr) {
        foreach($arr as $x) {
            if ($x != "A" && $x != "B" && $x != "C") return false;
        }
        return true;
    }

    function compress($cmds) {
        // $cmds = implode(",", $cmds);
        // $n = strlen($cmds);
        $n = count($cmds);
        for($i = 0; $i < $n; $i++) {
            $a = implode(",", array_slice($cmds, 0, $i+1));
            if (strlen($a) > 20) break;
            $cmdsAfterA = explode(",", str_replace($a, "A", implode(",", $cmds)));
            // echo $a."\n".implode(",",$cmdsAfterA)."\n";
            $bStart = 0;
            while($cmdsAfterA[$bStart] == "A") $bStart++;
            for($j = $bStart; $j < count($cmdsAfterA); $j++) {
                if($cmdsAfterA[$j] == "A") {
                    break;
                }
                $b = implode(",", array_slice($cmdsAfterA, $bStart, $j-$bStart+1));
                if(strlen($b) > 20) break;
                $cmdsAfterB = explode(",", str_replace($b, "B", implode(",", $cmdsAfterA)));
                // echo "A=".$a."\nB=".$b."\nM=".implode(",",$cmdsAfterB)."\n";
                $cStart = 0;
                while($cmdsAfterB[$cStart] == "A" || $cmdsAfterB[$cStart] == "B") $cStart++;
                for($k = $cStart; $k < count($cmdsAfterB); $k++) {
                    if($cmdsAfterB[$k] == "A" || $cmdsAfterB[$k] == "B") {
                        break;
                    }
                    $c = implode(",", array_slice($cmdsAfterB, $cStart, $k-$cStart+1));
                    if(strlen($c) > 20) break;
                    $cmdsAfterC = explode(",", str_replace($c, "C", implode(",", $cmdsAfterB)));
                    $main = implode(",", $cmdsAfterC);
                    if (strlen($main) <= 20 && onlyLettersLeft($cmdsAfterC)) {
                        return array($a, $b, $c, $main);
                    }
                }

            }
        }
        return array("", "", "", "");
    }

    function solve2() {
        $lines = getOutput("in2");
        $n = count($lines);
        $m = strlen($lines[0]);
        $posI = -1;
        $posJ = -1;
        $dir = "";
        for ($i = 0; $i < $n; $i++) {
            for($j = 0; $j < $m; $j++) {
                $c = $lines[$i][$j];
                if($c != "#" && $c != ".") {
                    $posI = $i;
                    $posJ = $j;
                    $dir = $c;
                }
            }
        }
        $cmds = array();
        $currLen = 0;
        while(true) {
            if (getChar($lines, $posI, $posJ, $dir) != "#") {
                if ($currLen != 0) {
                    array_push($cmds, $currLen);
                }
                $currLen = 0;
                if (getChar($lines, $posI, $posJ, turn($dir, "L")) == "#") {
                    array_push($cmds, "L");
                    $dir = turn($dir, "L");
                } else if(getChar($lines, $posI, $posJ, turn($dir, "R")) == "#") {
                    array_push($cmds, "R");
                    $dir = turn($dir, "R");
                } else {
                    break;
                }
            }
            $currLen++;
            list($posI, $posJ) = move($posI, $posJ, $dir);
        }
        list($a, $b, $c, $main) = compress($cmds);
        // echo "Main = ".$main."\n";
        // echo "A = ".$a."\n";
        // echo "B = ".$b."\n";
        // echo "C = ".$c."\n";
        $stdin = implode("\n", array($main, $a, $b, $c, "n"));
        $finalOutput = array_filter(getOutput("in2", true, $stdin));
        return intval(end($finalOutput));
    }
    
    $ans1 = solve1();
    echo "Part 1: ".$ans1."\n";
    $ans2 = solve2();
    echo "Part 2: ".$ans2."\n";
?>