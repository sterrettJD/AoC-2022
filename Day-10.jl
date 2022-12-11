function parse_line(line, x, cycle_num)
    if line=="noop"
        return x, cycle_num+1
    end

    new_add = parse(Int, line[5:length(line)])
    x += new_add
    return x, cycle_num+2
end

function run_cycle(x, to_add)
    
    index = 1
    for adder in to_add
        if adder.remaining==0
            x += adder.value
            deleteat!(to_add, index)
        else 
            adder.remaining -= 1
        end

        index += 1
    end

    return x, to_add
end

function check_strength(cycle_num, 
                        to_check, curr_check_index, checkpoint_strengths, 
                        x)
    if cycle_num in to_check[curr_check_index]-1:to_check[curr_check_index]
        strength = to_check[curr_check_index] * x
        println("Cycle: ", cycle_num, 
                ", x=", x, 
                ", strength=", strength)

        push!(checkpoint_strengths, strength)

        curr_check_index = min(curr_check_index + 1, length(to_check))
    end
    return checkpoint_strengths, curr_check_index
end


function solution(file)
    x = 1
    to_check = [20, 60, 100, 140, 180, 220]
    curr_check_index = 1

    checkpoint_strengths = Vector{Int}()

    f = open(file)

    cycle_num = 1
    for line in readlines(f)
        #println(line)
        x, cycle_num = parse_line(line, x, cycle_num)
        #x, to_add = run_cycle(x, to_add)

        checkpoint_strengths, curr_check_index = check_strength(cycle_num,
                                                                to_check, 
                                                                curr_check_index, 
                                                                checkpoint_strengths, 
                                                                x)
    end
    close(f)

    println("Sum of checkpoint strengths is ", sum(checkpoint_strengths))
end

solution("Day-10-test.txt")
solution("Day-10-data.txt")