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

file_count = length(findall(x->x≥0,expanded))
free_space = findall(x->x<0,expanded)                             # indices of all free space locations
swaps = length(free_space) - 1                                    # number of files to swap with free space 
tail = expanded[reverse(findall(x->x≥0,expanded)[end-swaps:end])] # tail files to swap for free space
expanded[free_space] = tail                                       # swap files with free space
expanded = expanded[1:file_count]                                 # trim free space

sum([i*expanded[i+1] for i=0:(length(expanded)-1)])