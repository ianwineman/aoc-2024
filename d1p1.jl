input = "3   4
4   3
2   5
1   3
3   9
3   3"

left_list  = sort(map(x->parse(Int64,split(x, " ")[1  ]), split(input, "\n")))
right_list = sort(map(x->parse(Int64,split(x, " ")[end]), split(input, "\n")))
sum(map(abs, left_list .- right_list))
