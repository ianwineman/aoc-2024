mutable struct Computer
    registerA::Int64
    registerB::Int64
    registerC::Int64
    instructionPointer::Int64
    program::Vector{Int64}
    output::Vector{Int64}
end

function combo(c::Computer, operand::Int64)::Int64
    (7 > operand >= 0) ? (return [0,1,2,3,c.registerA,c.registerB,c.registerC][operand+1]) : (error("illegal operand"))
end

function adv!(c::Computer, operand::Int64)
    c.registerA = trunc(c.registerA / (2^(combo(c,operand))))
end

function bdv!(c::Computer, operand::Int64)
    c.registerB = trunc(c.registerA / (2^(combo(c,operand))))
end

function cdv!(c::Computer, operand::Int64)
    c.registerC = trunc(c.registerA / (2^(combo(c,operand))))
end

function bxl!(c::Computer, operand::Int64)
    c.registerB = c.registerB ⊻ operand
end

function bst!(c::Computer, operand::Int64)
    c.registerB = combo(c,operand) % 8
end

function jnz!(c::Computer, operand::Int64)
    if c.registerA == 0
        return
    else
        c.instructionPointer = (operand - 2)
    end
end

function bxc!(c::Computer, operand::Int64)
    c.registerB = c.registerB ⊻ c.registerC
end

function out!(c::Computer, operand::Int64)
    push!(c.output, combo(c,operand) % 8)
end

####
input = "Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0"

registers = map(x->parse(Int64,split(x,": ")[2]),split(split(input,"\n\n")[1],"\n"))
program   = map(x->parse(Int64,x),split(split(split(input, "\n\n")[2]," ")[2],","))
comp      = Computer(registers...,0,program,[])

while comp.instructionPointer + 1 < length(comp.program)
    opcode  = comp.program[comp.instructionPointer+1]
    oper    = comp.program[comp.instructionPointer+2]

    if     opcode == 0
        adv!(comp,oper)
    elseif opcode == 1
        bxl!(comp,oper)
    elseif opcode == 2
        bst!(comp,oper)
    elseif opcode == 3
        jnz!(comp,oper)
    elseif opcode == 4
        bxc!(comp,oper)
    elseif opcode == 5
        out!(comp,oper)
    elseif opcode == 6
        bdv!(comp,oper)
    elseif opcode == 7
        cdv!(comp,oper)
    end
    comp.instructionPointer += 2
end

join(comp.output,",")