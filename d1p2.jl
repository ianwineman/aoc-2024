input = "3   4
4   3
2   5
1   3
3   9
3   3"

left_list  = map(x->parse(Int64,split(x, " ")[1  ]), split(input, "\n"))
right_list = map(x->parse(Int64,split(x, " ")[end]), split(input, "\n"))
sum([i * length([j for j=right_list if j == i]) for i=left_list])
