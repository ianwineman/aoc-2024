input = "2333133121414131402"
blocks      = [parse(Int64,input[i]) for i=1:length(input) if i % 2 == 1]
free_spaces = [parse(Int64,input[i]) for i=1:length(input) if i % 2 == 0]
expanded    = []

for i=1:length(blocks)
    push!(expanded, [i-1 for j=1:blocks[i]]...)
    if i != length(blocks)
        push!(expanded, [-1 for j=1:free_spaces[i]]...) # -1s to represent free space
    end
end

for file_index=sort(unique(expanded),rev=true)[1:end-2]
    block_locations = findall(x->x==file_index,expanded)
    free_space_locations = findall(x->x<0,expanded)

    for i=1:(length(free_space_locations)-length(block_locations))
        if (free_space_locations[i:(i+length(block_locations)-1)] == collect(free_space_locations[i]:1:free_space_locations[i+length(block_locations)-1])) && (block_locations[1] > free_space_locations[i:(i+length(block_locations)-1)][end])
            expanded[free_space_locations[i:(i+length(block_locations)-1)]], expanded[block_locations] = expanded[block_locations], expanded[free_space_locations[i:(i+length(block_locations)-1)]]
            break
        end
    end
end
sum([(expanded[i+1]>0) ? i*expanded[i+1] : 0 for i=0:(length(expanded)-1)])