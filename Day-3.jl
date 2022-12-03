filepath = "Day-3-data.txt";

f = open(filepath, "r");

function letter_to_priority(letter)
    val = Int(letter)

    if val > 96
        val = val - 96
    else
        val = val - 38
    end

    return val
end


function find_dup(c1, c2)
    for c in c1
        if occursin(c, c2)
            return c
        end
    end
end


total = 0 
for line in readlines(f)
    len = length(line)

    c1 = SubString(line, 1:len÷2)
    c2 = SubString(line, (len÷2)+1:len)

    dup = find_dup(c1, c2)

    val = letter_to_priority(Char(dup))

    println(dup, ": ", val)
    global total += val

end

println(total)

close(f)