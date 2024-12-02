input = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

safe_reports = 0
for report in split(input, "\n")
    levels = map(x->parse(Int64,x), split(report, " "))
    if issorted(levels) || issorted(levels,rev=true)
        distances = [abs(levels[i]-levels[i+1]) for i=1:(length(levels)-1)]
        if 1 <= minimum(distances) <= maximum(distances) <= 3
            global safe_reports+=1
        end
    end
end
safe_reports