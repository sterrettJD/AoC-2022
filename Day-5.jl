using DataStructures

function crane(stack_vector, num, from, to)
    for i in 1:num
        crate = pop!(stack_vector[from])
        push!(stack_vector[to], crate)
    end
end


function crane_9001(stack_vector, num, from, to)
    # add them to a temp stack so we can maintain the order
    temp = Stack{Char}()
    
    for i in 1:num
        crate = pop!(stack_vector[from])
        push!(temp, crate)
    end
    # then add them back to the real stack
    for i in 1:num
        crate = pop!(temp)
        push!(stack_vector[to], crate)
    end
end




file = "Day-5-data.txt"

f = open(file)


constructor = [Vector{Char}() for x in 1:9]

stack_vector = [Stack{Char}() for x in 1:9]
part_2_stack_vector = [Stack{Char}() for x in 1:9]

stacks_fully_constructed = false

for line in readlines(f)
    # constructing
    if contains(line, "[")
        for index in 1:9
            #println(index, line[index*4-2])
            if line[index*4-2] != ' '
                push!(constructor[index], line[index*4-2])
            end
        end
    end

    if stacks_fully_constructed
        # parse "move N from A into B"
        trash, num_to_move, trash2, from, trash3, to = split(line, " ")
        num_to_move = parse(Int, num_to_move)
        from = parse(Int, from)
        to = parse(Int, to)

        # do the moving
        crane(stack_vector, num_to_move, from, to)

        # do the moving for part 2
        crane_9001(part_2_stack_vector, num_to_move, from, to)
    end
    
    
    if line==""
        # This is where we create our stacks to be used
        # have to go over the vector with the data in reverse
        for i in 1:9
            for crate in Iterators.reverse(constructor[i])
                push!(stack_vector[i], crate)
                push!(part_2_stack_vector[i], crate)
            end
        end

        global stacks_fully_constructed = true
        println("STACK FULLY CONSTRUCTED")
        
        for i in 1:9
            println(i, ": ", part_2_stack_vector[i])
        end
    end
end

close(f)

println("Top crates for part 1 are: ")
for stack in stack_vector
    print(first(stack))
end

println("Top crates for part 2 are: ")
for stack in part_2_stack_vector
    print(first(stack))
end

println()

