input = "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"

lines = split(input, "\n")
input_dims = (length(lines), length(lines[1]))
input_matrix = fill("", input_dims)

for i=1:input_dims[1]
    for j=1:input_dims[2]
        input_matrix[i,j] = string(lines[i][j])
    end
end

re = r"[a-zA-Z0-9]"
antennas = map(y->(y[1].match,y[2]),filter(x->!isnothing(x[1]),[(match(re,string(input_matrix[i,j])),(i,j)) for i=1:input_dims[1] for j=1:input_dims[2]]))
antennas_dict = Dict{String,Vector{Tuple{Int64,Int64}}}()

for a in antennas
    if get(antennas_dict,a[1],false) == false
        antennas_dict[a[1]] = [a[2]]
    else
        push!(antennas_dict[a[1]],a[2])
    end
end

antinodes = []
for k in keys(antennas_dict)
    masks = filter(x->sum(x)==2,collect(Iterators.product([0:1 for i=1:length(antennas_dict[k])]...)))
    for m in masks
        pair = antennas_dict[k][findall(x->x==1,m)]
        p1, p2 = pair[1], pair[2]
        if sqrt(p1[1]^2 + p1[2]^2) > sqrt(p2[1]^2 + p2[2]^2)
            p1, p2 = p2, p1
        end
        slope = p2.-p1
        pair_antinodes = [p1.+(i,i).*slope for i=-max(input_dims[1],input_dims[2]):max(input_dims[1],input_dims[2])]
        pair_antinodes_f = filter(x->(1<=x[1]<=input_dims[1])&&(1<=x[2]<=input_dims[2]),pair_antinodes)
        push!(antinodes,pair_antinodes_f...)
    end
end
length(Set(antinodes))