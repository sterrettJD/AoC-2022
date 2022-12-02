mapper = Dict("A"=>1,"X"=>1,
              "B"=>2,"Y"=>2,
              "C"=>3,"Z"=>3)

function win_or_loss(p1, p2, mapper)
    # sanitize entries to be comparable first
    mp1 = mapper[p1]
    mp2 = mapper[p2]
    # draw is the simplest case
    if (mp1==mp2)
        return 3
    end

    # conditionals for non-draws
    if (mp1==1)
        # p2 win (rock vs paper)
        if (mp2==2)
            return 6
        else # p2 loss
            return 0
        end
    elseif (mp1==2)
        if (mp2==3) # win
            return 6
        else        # loss
            return 0
        end
    elseif (mp1==3)
        if (mp2==1) # win
            return 6
        else        # loss
            return 0
        end
    end
end



function points_for_choice(p2, mapper)
    return mapper[p2]
end

filepath = "Day-2-data.txt";

f = open(filepath, "r");

curr_total = 0

for line in readlines(f)
    p1 = SubString(line,1:1)
    p2 = SubString(line, 3:3)

    global curr_total += points_for_choice(p2, mapper)
    global curr_total += win_or_loss(p1, p2, mapper)

end

println("Player 2 received ", curr_total, " points.")
close(f)