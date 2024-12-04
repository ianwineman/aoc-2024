const INPUT: &str = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";

use regex::Regex;
fn main() {
    let re = Regex::new(r"mul\((\d{1,3}),(\d{1,3})\)").unwrap();
    let ans: i32 = re.captures_iter(INPUT)
                    .map(
                        |c| c.get(1).unwrap().as_str().parse::<i32>().unwrap()
                            *
                            c.get(2).unwrap().as_str().parse::<i32>().unwrap()
                    )
                    .sum();

    println!("{:?}", ans);
}