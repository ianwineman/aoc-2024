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

acum = 0
for i=2:(input_dims[1]-1)
    for j=2:(input_dims[2]-1)
        a = join([input_matrix[i-1,j-1], input_matrix[i,j], input_matrix[i+1,j+1]])
        b = join([input_matrix[i+1,j-1], input_matrix[i,j], input_matrix[i-1,j+1]])
        if (a == "MAS" || a == "SAM") && (b == "MAS" || b == "SAM")
            global acum += 1
        end
    end
end
acum