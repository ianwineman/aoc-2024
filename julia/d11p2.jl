input = "125 17"

arrangement::Vector{Tuple{Int64,Int64}} = map(x->(1,parse(Int64,x)),split(input, " ")) # [(count,stone)]

function consolidated(arrangement::Vector{Tuple{Int64,Int64}})
    unique_stones = unique(map(x->x[2],arrangement))
    return [(sum([x[1] for x in arrangement if x[2] == u]),u) for u in unique_stones]
end

function transform(stone::Int64)
    if stone == 0
        return 1
    elseif length(string(stone)) % 2 == 0
        return parse(Int64,string(stone)[1:(length(string(stone))÷2)]), parse(Int64,string(stone)[(length(string(stone))÷2+1):end])
    else
        return stone * 2024
    end
end

for blink=1:75
    for k=keys(arrangement)
        count, stone = arrangement[k]
        t = transform(stone)
        (length(t) == 1) ? (arrangement[k] = (count,t)) : (arrangement[k] = (count,t[1]); push!(arrangement,(count,t[2])))
    end
    global arrangement = consolidated(arrangement)
end

sum(map(x->x[1],arrangement))