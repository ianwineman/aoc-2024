input = "Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279"

struct Machine
    a::Tuple{Int64,Int64}
    b::Tuple{Int64,Int64}
    prize::Tuple{Int64,Int64}
end

function issolvable(m::Machine)::Bool
    (m.prize[1] % gcd(m.a[1],m.b[1]) == 0) && (m.prize[2] % gcd(m.a[2],m.b[2]) == 0)
end

function solution(m::Machine)::Tuple{Int64,Int64}
    A = hcat(collect(m.a),collect(m.b))
    b = collect(m.prize)
    sol = A\b
    if isapprox(round(sol[1]), sol[1]; atol=1e-3) && isapprox(round(sol[2]), sol[2]; atol=1e-3)
        return (round(Int64,sol[1]),round(Int64,sol[2]))
    else
        return (0,0)
    end
end

function cost(solution::Tuple{Int64,Int64})::Int64
    return 3*solution[1] + solution[2]
end

####
machines = []
for machine in split(input,"\n\n")
    a_string, b_string, p_string = split(machine,"\n")
    a_match = match(r"X(\+|=)(?<X>\d+),\sY(\+|=)(?<Y>\d+)",a_string)
    b_match = match(r"X(\+|=)(?<X>\d+),\sY(\+|=)(?<Y>\d+)",b_string)
    p_match = match(r"X(\+|=)(?<X>\d+),\sY(\+|=)(?<Y>\d+)",p_string)
    
    m = Machine(
        (parse(Int64,a_match[:X]), parse(Int64,a_match[:Y])),
        (parse(Int64,b_match[:X]), parse(Int64,b_match[:Y])),
        (parse(Int64,p_match[:X])+10000000000000, parse(Int64,p_match[:Y])+10000000000000)
    )
    push!(machines,m)
end

tokens = 0
for machine in machines
    if issolvable(machine)
        global tokens += cost(solution(machine))
    end
end
tokens