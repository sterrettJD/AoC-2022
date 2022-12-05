file = "Day-4-data.txt"

f = open(file)


function split_elves(line)
    # splits one line into 2 elves
    each_elf = split(line, ",")
    return each_elf
end

function split_range(elf)
    # splits each elf into a start and stop
    splitted = split(elf, "-")
    return parse.(Int, splitted)
end

function is_inside(parsed_line)
    elf_1_start = parsed_line[1][1]
    elf_1_stop = parsed_line[1][2]
    elf_2_start = parsed_line[2][1]
    elf_2_stop = parsed_line[2][2]

    # if 1 starts earlier, see if it ends later too
    if elf_1_start <= elf_2_start && elf_1_stop >= elf_2_stop
        return true
    # if 2 starts earlier, see if it ends later too
    elseif elf_2_start <= elf_1_start && elf_2_stop >= elf_1_stop
        return true
    # not inside
    else
        return false
    end        
end

function is_overlapping(parsed_line)
    elf_1_start = parsed_line[1][1]
    elf_1_stop = parsed_line[1][2]
    elf_2_start = parsed_line[2][1]
    elf_2_stop = parsed_line[2][2]

    # does elf 1 overlap 2 on its low end?
    if (elf_1_start >= elf_2_start) && (elf_1_start <= elf_2_stop)
        return true
    # does elf 1 overlap 2 on its high end?
    elseif (elf_1_stop >= elf_2_start) && (elf_1_stop <= elf_2_stop)
        return true
    # does elf 2 overlap 1 on its low end?
    elseif (elf_2_start >= elf_1_start) && (elf_2_start <= elf_1_stop)
        return true
    # does elf 2 overlap 1 on its high end?
    elseif (elf_2_stop >= elf_1_start) && (elf_2_stop <= elf_1_stop)
        return true
    else
        return false
    end
end


redundant_pairs = 0
overlapping_pairs = 0

for line in readlines(f)
    each_elf = split_elves(line)
    each_range = [split_range(x) for x in each_elf]

    if is_inside(each_range)
        #println(line)
        global redundant_pairs += 1
    end

    if is_overlapping(each_range)
        println(line)
        global overlapping_pairs += 1
    end
end
close(f)

println("There were ", redundant_pairs, " total redundant pairs.")
println("There were ", overlapping_pairs, " total overlapping pairs.")