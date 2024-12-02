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

    let left_list:  Vec<i32> = list_of_lists.clone().into_iter().map(|x| x[0]).collect::<Vec<i32>>();
    let right_list: Vec<i32> = list_of_lists.into_iter().map(|x| x[1]).collect::<Vec<i32>>();

    let acum: i32 = left_list
                      .into_iter()
                      .map(
                        |x| x * right_list
                                  .clone()
                                  .into_iter()
                                  .filter(|y| *y == x)
                                  .collect::<Vec<_>>()
                                  .len() as i32
                      )
                      .sum();

    println!("{}", acum);
}
