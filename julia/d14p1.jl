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

dims = (11,7)
seconds = 100

quadrant_counts = zeros(Int64,4)
for line in split(input,"\n")
    p, v = split(line, " ")
    p, v = split(p[3:end],","), split(v[3:end],",")
    p, v = [parse(Int64, p[1]), parse(Int64, p[2])], [parse(Int64, v[1]), parse(Int64, v[2])]
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

    if p_later[1] < trunc(Int64,dims[1]/2) # left side
        if p_later[2] < trunc(Int64,dims[2]/2) # upper-left
            quadrant_counts[1] += 1
        elseif p_later[2] > trunc(Int64,dims[2]/2) # bottom-left
            quadrant_counts[2] += 1
        end
    elseif p_later[1] > trunc(Int64,dims[1]/2) # right side
        if p_later[2] < trunc(Int64,dims[2]/2) # upper-right
            quadrant_counts[3] += 1
        elseif p_later[2] > trunc(Int64,dims[2]/2) # bottom-right
            quadrant_counts[4] += 1
        end
    end
end

reduce(*,quadrant_counts)