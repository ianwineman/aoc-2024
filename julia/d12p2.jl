input = "RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE"

function inregion(location::Tuple{Int64,Int64},region::Vector{Tuple{Int64,Int64}})::Bool
    neighbors = [location.+i for i=[(1,0),(0,1),(-1,0),(0,-1)]]
    (length(intersect(Set(region),Set(neighbors))) > 0) ? (return true) : (return false)
end

function inregion(region1::Vector{Tuple{Int64,Int64}},region2::Vector{Tuple{Int64,Int64}})::Bool
    neighbors = [location.+i for i=[(1,0),(0,1),(-1,0),(0,-1)] for location=region1]
    (length(intersect(Set(region2),Set(neighbors))) > 0) ? (return true) : (return false)
end

function combine!(rd::Dict{Tuple{String, Int64}, Vector{Tuple{Int64, Int64}}})
    l = length(rd)
    for region1 in keys(region_dict)
        for region2 in keys(region_dict)
            if (region1 != region2) && (region1[1] == region2[1])
                if inregion(region_dict[region1],region_dict[region2])
                    push!(region_dict[region1],region_dict[region2]...)
                    region_dict[region1] = collect(Set(region_dict[region1]))
                    delete!(region_dict,region2)
                end
            end
        end
    end
    (l == length(rd)) ? (return) : (return combine!(rd))
end

function area(region::Vector{Tuple{Int64,Int64}})::Int64
    return length(region)
end

function perimeter(region::Vector{Tuple{Int64,Int64}})::Int64
    total = 0
    for plant in region
        contribution = 4
        neighbors = [plant.+i for i=[(1,0),(0,1),(-1,0),(0,-1)]]
        contribution -= length(intersect(Set(region),Set(neighbors)))
        total += contribution
    end
    return total
end

function corners(region::Vector{Tuple{Int64,Int64}},map::Matrix{String})::Int64
    total = 0
    for plant in region
        grid = fill("",(3,3))
        grid[2,2] = map[plant...]

        for i in [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]
            try
                if map[(plant.+i)...] != grid[2,2]
                    grid[((2,2).+i)...] = map[(plant.+i)...]
                else 
                    if (plant.+i) in region 
                        grid[((2,2).+i)...] = map[(plant.+i)...]
                    else
                        grid[((2,2).+i)...] = "0"
                    end
                end
            catch e
                grid[((2,2).+i)...] = "0" # "0" denotes off map location
            end
        end

        contribution = 0

        d1 = [(1,2),(2,3)]
        d2 = [(2,3),(3,2)]
        d3 = [(3,2),(2,1)]
        d4 = [(2,1),(1,2)]

        if (grid[d1[1]...] != grid[2,2]) && (grid[d1[2]...] != grid[2,2])
            contribution += 1
        end
        if (grid[d2[1]...] != grid[2,2]) && (grid[d2[2]...] != grid[2,2])
            contribution += 1
        end
        if (grid[d3[1]...] != grid[2,2]) && (grid[d3[2]...] != grid[2,2])
            contribution += 1
        end
        if (grid[d4[1]...] != grid[2,2]) && (grid[d4[2]...] != grid[2,2])
            contribution += 1
        end

        if (grid[d1[1]...] == grid[2,2]) && (grid[d1[2]...] == grid[2,2]) && (grid[1,3] != grid[2,2])
            contribution += 1
        end
        if (grid[d2[1]...] == grid[2,2]) && (grid[d2[2]...] == grid[2,2]) && (grid[3,3] != grid[2,2])
            contribution += 1
        end
        if (grid[d3[1]...] == grid[2,2]) && (grid[d3[2]...] == grid[2,2]) && (grid[3,1] != grid[2,2])
            contribution += 1
        end
        if (grid[d4[1]...] == grid[2,2]) && (grid[d4[2]...] == grid[2,2]) && (grid[1,1] != grid[2,2])
            contribution += 1
        end
        
        total += contribution
    end
    return total
end

function sides(region::Vector{Tuple{Int64,Int64}},map::Matrix{String})::Int64
    return corners(region,map) 
end

# Parse input into Matrix{String}
lines = split(input, "\n")
input_dims = (length(lines), length(lines[1]))
input_matrix = fill("",input_dims)
for i=1:input_dims[1]
    for j=1:input_dims[2]
        input_matrix[i,j] = string(lines[i][j])
    end
end

# Region data structure 
region_dict = Dict{Tuple{String,Int64},Vector{Tuple{Int64,Int64}}}()

# Add each plant to a region
for i=1:input_dims[1]
    for j=1:input_dims[2]
        plant = input_matrix[i,j]
        existing_regions = filter(k->k[1]==plant,keys(region_dict))

        # not existing regions of the same type
        if length(existing_regions) == 0
            region_dict[(plant,1)] = [(i,j)]
        else
            for region in existing_regions
                if inregion((i,j),region_dict[region])
                    # plant part of existing region of the same type
                    push!(region_dict[region],(i,j))
                    break
                else
                    # plant not in any existing regions of the same type
                    region_dict[(plant,length(existing_regions)+1)] = [(i,j)]
                end
            end
        end
    end
end

# Connect regions split across different keys
combine!(region_dict)

# Calculate total price
reduce(+,[area(r) * sides(r,input_matrix) for r in values(region_dict)])