mutable struct Addx
    value::Int
    remaining::Int
end

function update_addx_remaining(Addx)
    Addx.remaining -= 1
    return Addx.remaining
end

function parse_line(line, to_add)
    if line=="noop"
        return to_add
    end
    
    new_add = parse(Int, line[5:length(line)])
    new_addx = Addx(new_add, 1)
    push!(to_add, new_addx)

    return to_add
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


function solution(file)
    x = 1
    to_add = Vector{Addx}()

    f = open(file)

    cycle_num = 1
    for line in readlines(f)
        println(line)
        to_add = parse_line(line, to_add)
        x, to_add = run_cycle(x, to_add)

        if cycle_num % 20 == 0
            println(x)
        end

        println(x)
        println(to_add)
        cycle_num += 1
    end
    close(f)
end

solution("Day-10-test.txt")