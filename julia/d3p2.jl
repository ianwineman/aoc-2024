input = raw"xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

chunks = split(input, "don't()")
valid = [chunks[1]]
for i in 2:length(chunks)
    if contains(chunks[i], "do()")
        push!(valid, replace(chunks[i], r".*?do\(\)" => ""; count=1))
    end
end

re = r"mul\((\d{1,3}),(\d{1,3})\)"
sum(
    [
        parse(Int64,match.captures[1]) * parse(Int64,match.captures[2]) 
        for match in eachmatch(re, join(valid))
    ]
)