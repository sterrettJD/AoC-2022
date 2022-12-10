# After doing part 2, I could use my new functions to complete part 1 
# in a much more concise manner.
# But I don't feel like making those changes right now.
# We will have long, and easy to read code for part 1.
# Part 2 is maybe shorter and easier to read code... 
# Demonstrates the learning process :)

function move_1(h_x, h_y, 
                t_x, t_y, 
                sign # should be 1 or -1
                )
    # h is head, t is tail
    # x is the movement direction, whereas y not
    # if overlapping
    if ((h_x==t_x) && (h_y==t_y))
        new_h_x = h_x + sign
        return new_h_x, h_y, t_x, t_y
    end

    # if already on the same y
    if ((h_x!=t_x) && (h_y==t_y))
        # if we're moving head onto tail
        if((h_x+sign) == t_x)
            new_h_x = t_x
            new_t_x = t_x # doesn't change
        else
            new_h_x = h_x + sign
            new_t_x = t_x + sign
        end
        return new_h_x, h_y, new_t_x, t_y
    end

    # if not on the same y, and x is different
    if ((h_x!=t_x) && (h_y!=t_y))
        # if moving head aligns it with tail, just move head
        if h_x + sign == t_x
            new_h_x = t_x
            return new_h_x, h_y, t_x, t_y
        end
        # otherwise diagonal movement of tail
        new_h_x = h_x + sign
        new_t_x = t_x + sign
        new_t_y = h_y
        return new_h_x, h_y, new_t_x, new_t_y
    end

    # if not on the same y, but they have the same x
    if ((h_x==t_x) && (h_y!=t_y))
        new_h_x = h_x + sign
        return new_h_x, h_y, t_x, t_y
    end
end

function full_move(h_x, h_y, t_x, t_y,
                   direction, distance)
    curr_h_x, curr_h_y, curr_t_x, curr_t_y = (h_x, h_y, t_x, t_y)
    t_coords = Vector{Vector{Int}}()
    if direction=='R'
        for _ in 1:distance
            curr_h_x, curr_h_y, curr_t_x, curr_t_y = move_1(curr_h_x, curr_h_y, curr_t_x, curr_t_y,
                                                            1)
            push!(t_coords, [curr_t_x, curr_t_y])
        end
    elseif direction=='L'
        for _ in 1:distance
            curr_h_x, curr_h_y, curr_t_x, curr_t_y = move_1(curr_h_x, curr_h_y, curr_t_x, curr_t_y,
                                                            -1)
            push!(t_coords, [curr_t_x, curr_t_y])
        end
    elseif direction=='U'
        for _ in 1:distance
            curr_h_y, curr_h_x, curr_t_y, curr_t_x = move_1(curr_h_y, curr_h_x, curr_t_y, curr_t_x,
                                                            1)
            push!(t_coords, [curr_t_x, curr_t_y])
        end
    elseif direction=='D'
        for _ in 1:distance
            curr_h_y, curr_h_x, curr_t_y, curr_t_x = move_1(curr_h_y, curr_h_x, curr_t_y, curr_t_x,
                                                            -1)
            push!(t_coords, [curr_t_x, curr_t_y])
        end
    end

    return curr_h_x, curr_h_y, curr_t_x, curr_t_y, t_coords
end


function update_first_two(h_x, h_y, t_x, t_y,
                          direction)
    if direction=='R'
        h_x, h_y, t_x, t_y = move_1(h_x, h_y, t_x, t_y,
                                    1)
    elseif direction=='L'
        h_x, h_y, t_x, t_y = move_1(h_x, h_y, t_x, t_y,
                                    -1)
    elseif direction=='U'
        h_y, h_x, t_y, t_x = move_1(h_y, h_x, t_y, t_x,
                                    1)
    elseif direction=='D'
        h_y, h_x, t_y, t_x = move_1(h_y, h_x, t_y, t_x,
                                    -1)
    end

    return [h_x, h_y], [t_x, t_y]
end

function get_move_dist(diff)
    if diff==0
        return 0
    end

    return diff/abs(diff)
end

function update_next_knot(h_x, h_y, t_x, t_y)
    diff_x = h_x - t_x
    diff_y = h_y - t_y

    
    to_move_x = get_move_dist(diff_x)
    to_move_y = get_move_dist(diff_y)
    

    if (diff_x^2 + diff_y^2) <= 2
        return t_x, t_y
    end

    new_t_x = t_x + to_move_x
    new_t_y = t_y + to_move_y

    return new_t_x, new_t_y
    
    
end

function update_long_rope(coords::Vector{Vector{Int}}, direction, distance)
    tail_coords = Vector{Vector{Int}}()
    for _ in 1:distance
        
        coords[1], coords[2] = update_first_two(coords[1][1], coords[1][2], 
                                                coords[2][1], coords[2][2], 
                                                direction)

        for knot in 2:length(coords)-1
            new_t_x, new_t_y= update_next_knot(coords[knot][1], coords[knot][2], 
                                               coords[knot+1][1], coords[knot+1][2])

            coords[knot+1] = Vector([new_t_x, new_t_y])
        end
        push!(tail_coords, coords[10])
    end
    return coords, tail_coords
end


function solution(file)
    f = open(file)

    
    h_x = h_y = t_x = t_y = 0
    coords = Vector{Vector{Int}}()

    i = 0

    for line in readlines(f)
        direction = line[1]
        distance = parse(Int, line[3:length(line)])

        h_x, h_y, t_x, t_y, t_coords = full_move(h_x, h_y, t_x, t_y, 
                                                direction, distance)
        coords = vcat(coords, t_coords)    

    end
    close(f)

    println("Number of unique coordinates of tail: ",
            length(unique(coords)))

end

function solution_2(file)
    f = open(file)

    
    h_x = h_y = t_x = t_y = 0
    coords = [[h_x, h_y] for _ in 1:10]
    all_tail_coords = Vector{Vector{Int}}()

    i = 0

    for line in readlines(f)
        direction = line[1]
        distance = parse(Int, line[3:length(line)])

        coords, tail_coords = update_long_rope(coords, 
                                               direction, 
                                               distance)
        all_tail_coords = vcat(all_tail_coords, tail_coords)    

    end
    close(f)

    println("Number of unique coordinates of tail: ",
            length(unique(all_tail_coords)))

end


solution("Day-9-data.txt")
solution_2("Day-9-data.txt")