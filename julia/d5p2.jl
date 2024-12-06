input = "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"

ordering_rules = map(x->map(y->parse(Int64,y),split(x,"|")),split(split(input,"\n\n")[1],"\n"))
updates        = map(x->map(y->parse(Int64,y),split(x,",")),split(split(input,"\n\n")[2],"\n"))

order_dict = Dict{Int64,Vector{Int64}}()

for or in ordering_rules
    if get(order_dict,or[1],false) == false
        order_dict[or[1]] = [or[2]]
    else
        push!(order_dict[or[1]],or[2])
    end
end

corrected_middles = 0
for update in updates
    if 0 ∈ [update[(i+1):end] ⊆ get(order_dict, update[i], []) for i=1:(length(update)-1)]
        check = [[update[(i+1):end] ⊆ get(order_dict, update[i], []) for i=1:(length(update)-1)];1]
        while 0 ∈ check
            ones   = findall(x->x==1,check)
            zeros  = findall(x->x==0,check)
            update = [update[ones]; update[zeros]]
            check  = [[update[(i+1):end] ⊆ get(order_dict, update[i], []) for i=1:(length(update)-1)];1]
        end
        global corrected_middles += update[floor(Int64,length(update)/2)+1]
    end
end
corrected_middles