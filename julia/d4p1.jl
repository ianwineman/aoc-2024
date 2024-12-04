input = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

lines = split(input, "\n")
input_dims = (length(lines), length(lines[1]))
input_matrix = fill("", input_dims)

for i=1:input_dims[1]
    for j=1:input_dims[2]
        input_matrix[i,j] = string(lines[i][j])
    end
end

masks = []
push!(masks, [(i,j:j+3)    for i=1:input_dims[1]     for j=1:(input_dims[2]-3)]...) # left    > right masks
push!(masks, [(i,j+3:-1:j) for i=1:input_dims[1]     for j=1:(input_dims[2]-3)]...) # right   > left  masks
push!(masks, [(i:i+3,j)    for i=1:(input_dims[1]-3) for j=1:input_dims[2]    ]...) # up      > down  masks
push!(masks, [(i+3:-1:i,j) for i=1:(input_dims[1]-3) for j=1:input_dims[2]    ]...) # down    > up    masks

acum = 0
for m=masks
    if join(input_matrix[m[1],m[2]]) == "XMAS"
        global acum += 1
    end
end

using LinearAlgebra # for diag()
# \ diagonals (up & down)
for d=[join(diag(input_matrix, k)) for k=-input_dims[1]:input_dims[2]]
    global acum += length(collect(eachmatch(r"(XMAS)|(SAMX)", d; overlap=true)))
end

# / diagonals (up & down)
input_matrix_r = rotr90(input_matrix)
for d=[join(diag(input_matrix_r, k)) for k=-input_dims[2]:input_dims[1]]
    global acum += length(collect(eachmatch(r"(XMAS)|(SAMX)", d; overlap=true)))
end

acum