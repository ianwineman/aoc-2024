fn main() {
    let input: &str = "3   4
    4   3
    2   5
    1   3
    3   9
    3   3";

    let list_of_lists = input
    .split("\n")
    .collect::<Vec<_>>()
    .into_iter()
    .map(
      |x| x
            .split(" ")
            .collect::<Vec<_>>()
            .into_iter()
            .filter(|y| y.to_string().parse::<i32>().is_ok())
            .collect::<Vec<_>>()
            .into_iter()
            .map(
              |z| z.to_string().parse::<i32>().unwrap()
            )
            .collect::<Vec<_>>()
    )
    .collect::<Vec<_>>();

    let mut left_list:  Vec<i32> = list_of_lists.clone().into_iter().map(|x| x[0]).collect::<Vec<i32>>();
    let mut right_list: Vec<i32> = list_of_lists.into_iter().map(|x| x[1]).collect::<Vec<i32>>();

    left_list.sort();
    right_list.sort();

    let mut acum: i32 = 0;

    for i in 0..left_list.len() {
        acum += (left_list[i] - right_list[i]).abs();
    }

    println!("{}", acum);
}
