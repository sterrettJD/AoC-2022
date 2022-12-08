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

end



file = "Day-8-data.txt"

solution(file)