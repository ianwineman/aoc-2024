const INPUT: &str = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9";

fn safe_report(report: Vec<i32>) -> bool {
    if report.is_sorted() || report.is_sorted_by(|a, b| a >= b) {
        let distances: Vec<i32> = (0..(report.len()-1)).map(
                                                            |i| (report[i] - report[i+1]).abs()
                                                        )
                                                       .collect();

        if 1 <= *distances.iter().min().unwrap() 
              && distances.iter().min().unwrap() <= distances.iter().max().unwrap() 
              && *distances.iter().max().unwrap() <= 3 {
            return true
        }
        else { return false }
    }
    else { return false }
}

fn dampened_reports(report: Vec<i32>) -> Vec<Vec<i32>> {
    let mut reports: Vec<Vec<i32>> = Vec::new();

    for i in 0..report.len() {
        let mut rc = report.clone();
        rc.remove(i);
        reports.push(rc);
    }

    return reports
}

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
        for dr in dampened_reports(report) {
            if safe_report(dr) {
                safe_reports += 1;
                break;
            }
        }
    }
    println!("{}", safe_reports);
}
