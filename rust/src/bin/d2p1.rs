const INPUT: &str = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9";

fn main() {
    let reports: Vec<Vec<i32>> = INPUT.split("\n")
                       .map(
                        |x| x.split(" ")
                             .map(
                                |y| y.to_string()
                                     .parse::<i32>()
                                     .unwrap()
                             )
                             .collect::<Vec<i32>>()
                       )
                       .collect();

    let mut safe_reports: i32 = 0;
    for report in reports {
        if report.is_sorted() || report.is_sorted_by(|a, b| a >= b) {
            let distances: Vec<i32> = (0..(report.len()-1)).map(
                                                                |i| (report[i] - report[i+1]).abs()
                                                            )
                                                           .collect();

            if 1 <= *distances.iter().min().unwrap() 
                  && distances.iter().min().unwrap() <= distances.iter().max().unwrap() 
                  && *distances.iter().max().unwrap() <= 3 {
                safe_reports += 1;
            }
        }
    }
    println!("{}", safe_reports);
}
