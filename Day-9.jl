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


solution("Day-9-data.txt")