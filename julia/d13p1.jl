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

function solutions(m::Machine)::Vector{Tuple{Int64,Int64}}
    # ax + by = c
    A_a, A_b, A_c = m.a[1], m.b[1], m.prize[1] 
    A_v, A_u = A_b÷gcd(A_a,A_b), A_a÷gcd(A_a,A_b)
    A_x0, A_y0 = gcdx(A_a,A_b)[2]*(A_c÷gcd(A_a,A_b)), gcdx(A_a,A_b)[3]*(A_c÷gcd(A_a,A_b))
    A_ks = collect(round(Int64,max((0-A_x0)/A_v,(100-A_y0)/-A_u)):floor(Int64,min((100-A_x0)/A_v,(0-A_y0)/-A_u)))

    B_a, B_b, B_c = m.a[2], m.b[2], m.prize[2] 
    B_v, B_u = B_b÷gcd(B_a,B_b), B_a÷gcd(B_a,B_b)
    B_x0, B_y0 = gcdx(B_a,B_b)[2]*(B_c÷gcd(B_a,B_b)), gcdx(B_a,B_b)[3]*(B_c÷gcd(B_a,B_b))
    B_ks = collect(round(Int64,max((0-B_x0)/B_v,(100-B_y0)/-B_u)):floor(Int64,min((100-B_x0)/B_v,(0-B_y0)/-B_u)))

    A_solutions = [(A_x0+A_v*k,A_y0-A_u*k) for k=A_ks]
    B_solutions = [(B_x0+B_v*k,B_y0-B_u*k) for k=B_ks]

    return collect(intersect(Set(A_solutions),Set(B_solutions)))
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
        (parse(Int64,p_match[:X]), parse(Int64,p_match[:Y]))
    )
    push!(machines,m)
end

tokens = 0
solvable_machines = filter(m->issolvable(m),machines)
for sm in solvable_machines
    sm_solutions = solutions(sm)
    if length(sm_solutions) > 0
        global tokens += minimum([cost(s) for s=sm_solutions])
    end
end
tokens