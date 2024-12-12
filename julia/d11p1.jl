input = "125 17"
arrangement = map(x->parse(Int64,x),split(input, " "))

function transform(stone::Int64)
    if stone == 0
        return 1
    elseif length(string(stone)) % 2 == 0
        return parse(Int64,string(stone)[1:(length(string(stone))÷2)]), parse(Int64,string(stone)[(length(string(stone))÷2+1):end])
    else
        return stone * 2024
    end
end

for blink=1:6
    for k=keys(arrangement)
        t = transform(arrangement[k])
        (length(t) == 1) ?  (arrangement[k] = t) : (arrangement[k] = t[1]; push!(arrangement,t[2]))
    end
end 
length(arrangement)