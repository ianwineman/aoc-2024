input = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

function safe_report(levels::Vector{Int64})::Bool
    if issorted(levels) || issorted(levels,rev=true)
        distances = [abs(levels[i]-levels[i+1]) for i=1:(length(levels)-1)]
        if 1 <= minimum(distances) <= maximum(distances) <= 3 return true
        else return false
        end
    else return false end
end

function dampened_reports(levels::Vector{Int64})::Vector{Vector{Int64}}
    [levels[[j for j=1:length(levels) if j != i]] for i=1:length(levels)]
end

safe_reports = 0
for report in split(input, "\n")
    levels = map(x->parse(Int64,x), split(report, " "))
    for dr in dampened_reports(levels)
        if safe_report(dr) 
            global safe_reports += 1 
            break
        end
    end
end
safe_reports