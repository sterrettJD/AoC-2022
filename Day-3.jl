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



# Part 2

function find_common(l1, l2, l3)
    for c in l1
        if occursin(c, l2)
            if occursin(c, l3)
                return c
            end
        end
    end
end


f = open(filepath, "r")


line_counter = 1 
total = 0 

prev_line = ""
prev_prev_line = ""

for line in readlines(f)
    if line_counter > 2
        if line_counter % 3 ==0 
            println(line, " ", prev_line, " ", prev_prev_line)
            badge = find_common(line, prev_line, prev_prev_line)
            println(badge)
            global total += letter_to_priority(badge)

        end
        
        prev_prev_line = prev_line
        prev_line = line

    elseif line_counter==2
        global prev_line = line
    elseif line_counter==1
        global prev_prev_line = line
    end

    global line_counter += 1

end

println(total)

close(f)