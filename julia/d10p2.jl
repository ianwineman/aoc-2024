input = "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"

lines = split(input, "\n")
input_dims = (length(lines), length(lines[1]))
input_matrix = zeros(Int64,input_dims)

for i=1:input_dims[1]
    for j=1:input_dims[2]
        input_matrix[i,j] = parse(Int64,lines[i][j])
    end
end

trailheads = map(y->(y[1],y[2]),findall(x->x==0,input_matrix))

function rating(trailhead::Tuple{Int64,Int64},topo::Matrix{Int64})::Int64
    step_dict = Dict(i=>[] for i=0:9)
    step_dict[0] = [trailhead]
    for step in sort(collect(keys(step_dict)))
        for coord in step_dict[step]
            potential_moves = [coord.+i for i=[(1,0),(0,1),(-1,0),(0,-1)]]
            for pm in potential_moves
                if (1 ≤ pm[1] ≤ input_dims[1]) && (1 ≤ pm[2] ≤ input_dims[2])
                    if topo[coord[1],coord[2]] + 1 == topo[pm[1],pm[2]]
                        push!(step_dict[step+1],pm)
                    end
                end
            end
        end
    end
    return length(step_dict[9])
end

total_score = 0
for t=trailheads
    global total_score += rating(t,input_matrix)
end
total_score