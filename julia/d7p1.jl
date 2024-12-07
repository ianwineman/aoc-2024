input = "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"

function operator_test(equation::Tuple{Int64, Vector{Int64}})::Bool
    masks = collect(Iterators.product([0:1 for i=1:(length(equation[2])-1)]...))
    for m=masks
        acum = equation[2][1]
        for i=1:length(m)
            Bool(m[i]) ? acum*=equation[2][i+1] : acum+=equation[2][i+1]
        end
        if acum == equation[1] return true end
    end
    return false
end

parsed_input = map(x->(parse(Int64,x[1]),map(y->parse(Int64,y),split(x[2]," ")[2:end])),[split(i, ":") for i=split(input, "\n")])
sum(map(x->x[1],filter(y->operator_test(y),parsed_input)))