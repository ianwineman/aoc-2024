input = "########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<"

function update!(robot::Tuple{Int64,Int64},warehouse::Matrix{String},move::String)
    if move == "^"
        ahead = reverse(warehouse[1:(robot[1]-1),robot[2]])
        if ahead[1] == "#"
            return # stay put (can't move this direction)
        elseif ahead[1] == "."
            warehouse[robot...] = "."
            warehouse[(robot .+ (-1,0))...] = "@"
            return # move ahead in direction move
        elseif ahead[1] == "O"
            if ("." in ahead) && (findfirst(x->x==".",ahead) < findfirst(x->x=="#",ahead))
                warehouse[1:length(ahead),robot[2]] = reverse(["@"; ahead[1:(findfirst(x->x==".",ahead)-1)]; ahead[(findfirst(x->x==".",ahead)+1):end]])
                warehouse[robot...] = "."
                return # move ahead in direction move and push box(s) ahead
            else
                return # stay put (can't move this direction)
            end
        else return end # invalid warehouse contents
    elseif move == "v"
        ahead = warehouse[(robot[1]+1):end,robot[2]]
        if ahead[1] == "#"
            return # stay put (can't move this direction)
        elseif ahead[1] == "."
            warehouse[robot...] = "."
            warehouse[(robot .+ (1,0))...] = "@"
            return # move ahead in direction move
        elseif ahead[1] == "O"
            if ("." in ahead) && (findfirst(x->x==".",ahead) < findfirst(x->x=="#",ahead))
                warehouse[(end-length(ahead)+1):end,robot[2]] = ["@"; ahead[1:(findfirst(x->x==".",ahead)-1)]; ahead[(findfirst(x->x==".",ahead)+1):end]]
                warehouse[robot...] = "."
                return # move ahead in direction move and push box(s) ahead
            else
                return # stay put (can't move this direction)
            end
        else return end # invalid warehouse contents
    elseif move == ">"
        ahead = warehouse[robot[1],(robot[2]+1):end]
        if ahead[1] == "#"
            return # stay put (can't move this direction)
        elseif ahead[1] == "."
            warehouse[robot...] = "."
            warehouse[(robot .+ (0,1))...] = "@"
            return # move ahead in direction move
        elseif ahead[1] == "O"
            if ("." in ahead) && (findfirst(x->x==".",ahead) < findfirst(x->x=="#",ahead))
                warehouse[robot[1],(robot[2]+1):end] = ["@"; ahead[1:(findfirst(x->x==".",ahead)-1)]; ahead[(findfirst(x->x==".",ahead)+1):end]]
                warehouse[robot...] = "."
                return # move ahead in direction move and push box(s) ahead
            else
                return # stay put (can't move this direction)
            end
        else return end # invalid warehouse contents
    elseif move == "<"
        ahead = reverse(warehouse[robot[1],1:(robot[2]-1)])
        if ahead[1] == "#"
            return # stay put (can't move this direction)
        elseif ahead[1] == "."
            warehouse[robot...] = "."
            warehouse[(robot .+ (0,-1))...] = "@"
            return # move ahead in direction move
        elseif ahead[1] == "O"
            if ("." in ahead) && (findfirst(x->x==".",ahead) < findfirst(x->x=="#",ahead))
                warehouse[robot[1],1:(robot[2]-1)] = reverse(["@"; ahead[1:(findfirst(x->x==".",ahead)-1)]; ahead[(findfirst(x->x==".",ahead)+1):end]])
                warehouse[robot...] = "."
                return # move ahead in direction move and push box(s) ahead
            else
                return # stay put (can't move this direction)
            end
        else return end # invalid warehouse contents
    else return end # invalid move
end

warehouse_string = split(input,"\n\n")[1]
moves = map(ss->string(ss),split(split(input,"\n\n")[2],""))

lines = split(warehouse_string, "\n")
warehouse_dims = (length(lines), length(lines[1]))
warehouse = fill("",warehouse_dims)
for i=1:warehouse_dims[1]
    for j=1:warehouse_dims[2]
        warehouse[i,j] = string(lines[i][j])
    end
end

for m in moves 
    robot = Tuple(findfirst(x->x=="@",warehouse))
    update!(robot,warehouse,m)
end

reduce(+,map(ci->(ci[1]-1)*100 + ci[2]-1,findall(x->x=="O",warehouse)))