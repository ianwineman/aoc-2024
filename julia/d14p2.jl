input = "p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"

function simulate(seconds::Int64,p::Vector{Int64},v::Vector{Int64},dims::Tuple{Int64,Int64})::Vector{Int64}
    p_later = p .+ (seconds .* v)

    if p_later[1] > dims[1]
        p_later[1] %= dims[1]
    elseif p_later[1] < 0
        p_later[1] %= dims[1]
        if p_later[1] < 0
            p_later[1] += dims[1]
        end
    end
    if p_later[2] > dims[2]
        p_later[2] %= dims[2]
    elseif p_later[2] < 0
        p_later[2] %= dims[2]
        if p_later[2] < 0
            p_later[2] += dims[2]
        end
    end

    return p_later
end

s = 0
open("tree.txt", "w") do file
    write(file, "")
end
while s < 10000
    dims = (101,103)
    robots = []
    for line in split(input,"\n")
        p, v = split(line, " ")
        p, v = split(p[3:end],","), split(v[3:end],",")
        p, v = [parse(Int64, p[1]), parse(Int64, p[2])], [parse(Int64, v[1]), parse(Int64, v[2])]    
        push!(robots,(p,v))
    end
    robots = map(
        x->simulate(s,x[1],x[2],dims),
        robots
    )

    d = fill(".",(dims[2],dims[1]))

    for r in robots
        i = (r[2] == 0) ? (r[2] + 1) : (r[2])
        j = (r[1] == 0) ? (r[1] + 1) : (r[1])

        d[i,j] = "#"
    end
    
    open("tree.txt", "a") do file
        write(file, "Seconds = $s \n")
        write(file, join([join(d[i,:],"") for i=1:size(d)[1]],"\n"))
        write(file, "\n\n")
    end

    global s += 1
end