input = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."

lines = split(input, "\n")
input_dims = (length(lines), length(lines[1]))
input_matrix = fill("", input_dims)

for i=1:input_dims[1]
    for j=1:input_dims[2]
        input_matrix[i,j] = string(lines[i][j])
    end
end

mutable struct Guard
    facing::Int64                    # 0:3 -> N,E,S,W
    position::Tuple{Int64, Int64}    # x,y of current position
    visits::Set{Tuple{Int64, Int64}} # x,y of previous positions
end

function rotate!(g::Guard)
    g.facing = (g.facing + 1) % 4
end

function step!(g::Guard)
    push!(g.visits,g.position)
    if g.facing == 0     # N
        g.position = (g.position[1]-1, g.position[2])
    elseif g.facing == 1 # E
        g.position = (g.position[1], g.position[2]+1)
    elseif g.facing == 2 # S
        g.position = (g.position[1]+1, g.position[2])
    elseif g.facing == 3 # W
        g.position = (g.position[1], g.position[2]-1)
    else 
        println("Err: g.facing = $(g.facing)")
        return
    end
end

function ahead(g::Guard, m::Matrix{String})::String
    if g.facing == 0     # N
        x,y = g.position
        return m[x-1,y]
    elseif g.facing == 1 # E
        x,y = g.position
        return m[x,y+1]
    elseif g.facing == 2 # S
        x,y = g.position
        return m[x+1,y]
    elseif g.facing == 3 # W
        x,y = g.position
        return m[x,y-1]
    else 
        println("Err: g.facing = $(g.facing)")
        return
    end
end

guard = Guard(0, findfirst(x->x=="^", input_matrix), Set())
while true
    if (guard.facing == 0) && (guard.position[1] == 1)                 # N
        break
    elseif (guard.facing == 1) && (guard.position[2] == input_dims[2]) # E
        break
    elseif (guard.facing == 2) && (guard.position[1] == input_dims[1]) # S
        break
    elseif (guard.facing == 3) && (guard.position[2] == 1)             # W
        break
    end

    if ahead(guard, input_matrix) == "#"
        rotate!(guard)
    else
        step!(guard)
    end
end
push!(guard.visits,guard.position)
length(guard.visits)