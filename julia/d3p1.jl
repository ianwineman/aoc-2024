input = raw"xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

re = r"mul\((\d{1,3}),(\d{1,3})\)"
sum(
    [
        parse(Int64,match.captures[1]) * parse(Int64,match.captures[2]) 
        for match in eachmatch(re, input)
    ]
)