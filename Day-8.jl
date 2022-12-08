function is_visible(tree, row, col, row_index, col_index)
    
    row_trees_greater_left = sum(map(x -> x >= tree, 
                                     row[1:row_index-1]))
    row_trees_greater_right = sum(map(x -> x >= tree, 
                                     row[row_index+1:length(row)]))

    col_trees_greater_left = sum(map(x -> x >= tree, 
                                     col[1:col_index-1]))
    col_trees_greater_right = sum(map(x -> x >= tree, 
                                     col[col_index+1:length(row)]))

    # if any are 0, that will make vis 0
    vis = prod([row_trees_greater_left, row_trees_greater_right,
                col_trees_greater_left, col_trees_greater_right])

    return vis==0
end


function get_total_vis(mat)
    visible_counter = 0
    nrow, ncol = size(mat)
    for i in 1:nrow
        for j in 1:ncol
            visible_counter += is_visible(mat[i,j],
                                          mat[i,:],
                                          mat[:,j],
                                          j,
                                          i)
        end
    end
    return visible_counter
end


function get_scenic_score(tree, row, col, row_index, col_index)
    view_left = view_right = view_up = view_down = 0
    # left
    for i in range(row_index-1, 1, step=-1)
        view_left += 1
        if row[i] >= tree
            break
        end
    end
    # right
    for i in range(row_index+1, length(row))
        view_right += 1
        if row[i] >= tree
            break
        end
    end
    # up
    for i in range(col_index-1, 1, step=-1)
        view_up += 1
        if col[i] >= tree
            break
        end
    end
    # down
    for i in range(col_index+1, length(col))
        view_down += 1
        if col[i] >= tree
            break
        end
    end

    views = [view_left, view_right,
            view_up, view_down]
    
    scenic_score = prod(views)
    return scenic_score    
end

function get_max_scenic_score(mat)
    max_score = 0
    nrow, ncol = size(mat)
    for i in 1:nrow
        for j in 1:ncol
            this_score = get_scenic_score(mat[i,j],
                                          mat[i,:],
                                          mat[:,j],
                                          j,
                                          i)
            max_score = max(max_score, this_score)
        end
    end
    return max_score
end

function solution(file)
    f = open(file)
    
    vec = Vector{Vector{Int}}()

    for line in readlines(f)
        line_vec = [parse(Int,char) for char in line]
        
        push!(vec, line_vec)
        #println(line_vec)
        
    end
    close(f)
    mat = reduce(hcat,vec)'

    total_visible = get_total_vis(mat)
    println("Number of visible trees: ", total_visible)

    score = get_max_scenic_score(mat)
    println("Maximum scenic score: ", score)
end



file = "Day-8-data.txt"

solution(file)