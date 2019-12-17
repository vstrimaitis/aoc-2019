use std::collections::HashMap;
use std::io::{self, stdin, Read};

#[derive(Debug)]
struct Recipe {
    produces: u64,
    requires: Vec<(u64, String)>,
}

fn read() -> String {
    let mut input = String::new();
    let _ = stdin().read_to_string(&mut input);
    input
}

fn parse_single(s: &str) -> (u64, String) {
    let parts: Vec<&str> = s.split(" ").collect();
    (parts[0].parse().unwrap(), parts[1].to_string())
}

fn parse_line(line: &str, edges: &mut HashMap<String, Recipe>) {
    let parts: Vec<&str> = line.split(" => ").collect();
    let src_parts: Vec<&str> = parts[1].split(" ").collect();

    let recipe = Recipe {
        produces: src_parts[0].parse().unwrap(),
        requires: parts[0].split(", ").map(|x| parse_single(x)).collect(),
    };

    edges.insert(src_parts[1].to_string(), recipe);
}

fn parse_input(input: &str) -> HashMap<String, Recipe> {
    let mut edges = HashMap::new();
    let lines: Vec<&str> = input.split("\n").filter(|x| x.len() > 0).collect();
    for line in lines {
        parse_line(line, &mut edges);
    }
    edges
}

fn get_multiple(x: u64, m: u64) -> u64 {
    let mut res = x / m;
    if x % m != 0 {
        res += 1;
    }
    res * m
}

fn toposort(recipes: &HashMap<String, Recipe>, fuel_count: u64) -> HashMap<String, u64> {
    let mut needs = HashMap::new();
    let mut in_degs = HashMap::new();
    for k in recipes.keys() {
        needs.insert(k.to_string(), 0);
        // in_degs.insert(k.to_string(), 0);
    }
    for (_, k) in recipes.values().flat_map(|x| &x.requires) {
        let cnt = in_degs.entry(k).or_insert(0);
        *cnt += 1;
    }
    let mut nodes = vec!["FUEL"];
    needs.insert("FUEL".to_string(), fuel_count);
    // println!("in_degs: {:?}", in_degs);
    while nodes.len() > 0 {
        let u = nodes.pop().unwrap();
        // println!("node: {:?}", u);
        if !recipes.contains_key(u) {
            continue;
        }
        *needs.entry(u.to_string()).or_insert(0) = get_multiple(needs[u], recipes[u].produces);
        // println!("in_degs: {:?}", in_degs);
        for (amount, v) in &recipes[u].requires {
            *needs.entry(v.to_string()).or_insert(0) += needs[u] * amount / recipes[u].produces;
            let in_deg = in_degs.entry(v).or_insert(0);
            *in_deg -= 1;
            if *in_deg == 0 {
                nodes.push(v);
            }
        }
    }
    needs
}

fn get_ore_count(recipes: &HashMap<String, Recipe>, fuel_count: u64) -> u64 {
    let needs = toposort(recipes, fuel_count);
    needs["ORE"]
}

fn solve_part_two(recipes: &HashMap<String, Recipe>) -> u64 {
    let mut lo: u64 = 0;
    let mut hi: u64 = 1000000000;
    while lo < hi {
        let mid = (lo + hi + 1) / 2;
        let ore_count = get_ore_count(recipes, mid);
        if ore_count > 1000000000000 {
            hi = mid - 1;
        } else {
            lo = mid;
        }
    }
    lo
}

fn main() -> io::Result<()> {
    let input = read();
    let edges = parse_input(&input);
    println!("Part 1: {}", get_ore_count(&edges, 1));
    println!("Part 2: {}", solve_part_two(&edges));
    Ok(())
}
