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
    facing::Int64                              # 0:3 -> N,E,S,W
    position::Tuple{Int64, Int64}              # x,y of current position
    visits::Set{Tuple{Int64, Int64}}           # x,y of previous positions
    visits_ex::Set{Tuple{Int64, Int64, Int64}} # x,y,facing of previous positions
end

function rotate!(g::Guard)
    g.facing = (g.facing + 1) % 4
end

function step!(g::Guard)
    push!(g.visits,g.position)
    push!(g.visits_ex,(g.position[1],g.position[2],g.facing))
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

function loop(g::Guard)::Bool
    if (length(g.visits) > 1) && ((g.position[1], g.position[2], g.facing) ∈ g.visits_ex)
        return true
    else
        return false
    end
end

guard = Guard(0, findfirst(x->x=="^", input_matrix), Set(), Set())
start = guard.position
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

loop_obstacles = 0
for position=guard.visits
    if position != start
        modified_matrix = copy(input_matrix) # copy() is very important!
        modified_matrix[position[1],position[2]] = "#"
        test_guard = Guard(0, findfirst(x->x=="^", modified_matrix), Set(), Set())
        while !loop(test_guard)
            if (test_guard.facing == 0) && (test_guard.position[1] == 1)                 # N
                break 
            elseif (test_guard.facing == 1) && (test_guard.position[2] == input_dims[2]) # E
                break
            elseif (test_guard.facing == 2) && (test_guard.position[1] == input_dims[1]) # S
                break
            elseif (test_guard.facing == 3) && (test_guard.position[2] == 1)             # W
                break
            end

            if ahead(test_guard, modified_matrix) == "#"
                rotate!(test_guard)
            else
                step!(test_guard)
            end
        end
        if loop(test_guard)
            global loop_obstacles += 1
        end
    end
end
loop_obstacles