const INPUT: &str = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";

use regex::Regex;
fn main() {
    let chunks: Vec<&str> = INPUT.split("don't()").collect();

    let re_replace = Regex::new(r".*?do\(\)").unwrap();
    let mut valid: Vec<String> = chunks
                .iter()
                .filter(|x| x.contains("do()"))
                .map(|y| re_replace.replacen(y,1,"").into_owned())
                .collect();

    valid.push(chunks[0].to_owned());

    let re_mul = Regex::new(r"mul\((\d{1,3}),(\d{1,3})\)").unwrap();
    let ans: i32 = re_mul.captures_iter(&valid.join(""))
                    .map(
                        |c| c.get(1).unwrap().as_str().parse::<i32>().unwrap()
                            *
                            c.get(2).unwrap().as_str().parse::<i32>().unwrap()
                    )
                    .sum();

    println!("{:?}", ans);
}