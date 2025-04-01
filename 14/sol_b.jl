# Copyright (C) 2023 by Jan Philipp Thiele
#                                                                            
# This file is part of 23_julia
#                                                                            
# 23_julia is free software: you can redistribute it and/or modify  
# it under the terms of the GNU General Public License as          
# published by the Free Software Foundation, either                      
# version 3 of the License, or (at your option) any later version.          
#                                                                          
# 23_julia is distributed in the hope that it will be useful,       
# but WITHOUT ANY WARRANTY; without even the implied warranty of            
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.                       
# 
# You should have received a copy of the GNU General Public License  
# along with 23_julia. If not, see <http://www.gnu.org/licenses/>.  




# filename::String = "14/testinput.txt"
filename::String = "14/input.txt"
function print_stones(
    moving::Vector{CartesianIndex{2}},
    blocking::Vector{CartesianIndex{2}},
    n::Int64)
    for row ∈ 1:n
        for col ∈ 1:n
            printed = false
            for move ∈ moving
                if(move==CartesianIndex(row,col))
                    print('O')
                    printed = true
                    break
                end
            end
            if (!printed)
                for block ∈ blocking
                    if(block==CartesianIndex(row,col))
                        print('#')
                        printed = true
                        break
                    end
                end
            end
            if (!printed)
                print('.')
            end
        end
        println("")
    end
end

function move_cycles_and_calc_load(
    moving::Vector{CartesianIndex{2}}, 
    blocking::Vector{CartesianIndex{2}}, 
    n::Int64, 
    n_cycles::Int64)
    # print_stones(moving,blocking,n)
    history = Vector{Vector{CartesianIndex{2}}}([])
    period = 0
    for c ∈ 1:n_cycles
        # North
        for col ∈ 1:n
            col_moving = findall(x -> x[2] == col, moving)
            col_blocking = findall(x -> x[2] == col, blocking)
            for i ∈ eachindex(col_moving)
                k = 0
                if (i > 1)
                    k = moving[col_moving[i-1]][1]
                end
                if !isnothing(col_blocking)
                    for l ∈ eachindex(col_blocking)
                        blocker = blocking[col_blocking[l]]
                        if blocker[1] > moving[col_moving[i]][1]
                            break
                        end
                        k = maximum([k, blocker[1]])
                    end
                end
                moving[col_moving[i]]=CartesianIndex(k + 1, col)
            end
        end
        # println("North")
        # print_stones(moving,blocking,n)
        sort!(moving)
        for row ∈ 1:n
            row_moving = findall(x->x[1]==row,moving)
            row_blocking = findall(x->x[1]==row,blocking)
            sort!(row_blocking)
            sort!(row_moving)
            for j ∈ eachindex(row_moving)
                k = 0
                if (j>1)
                    k = moving[row_moving[j-1]][2]
                end
                if !isnothing(row_blocking)
                    for l ∈ eachindex(row_blocking)
                        blocker = blocking[row_blocking[l]]
                        if blocker[2] > moving[row_moving[j]][2]
                            break
                        end
                        k = maximum([k,blocker[2]])
                    end
                end
                moving[row_moving[j]]=CartesianIndex(row,k+1)
            end
        end
        # println("West")
        # print_stones(moving,blocking,n)
        sort!(moving)

        # sort!(moving,rev=true)
        for col ∈ 1:n
            col_moving = findall(x -> x[2] == col, moving)
            col_blocking = findall(x -> x[2] == col, blocking)
            for ii ∈ eachindex(col_moving)
                i = length(col_moving)-ii+1
                k = n+1
                if (i < length(col_moving))
                    k = moving[col_moving[i+1]][1]
                end
                if !isnothing(col_blocking)
                    for ll ∈ eachindex(col_blocking)
                        l = length(col_blocking)-ll+1
                        blocker = blocking[col_blocking[l]]
                        if blocker[1] < moving[col_moving[i]][1]
                            break
                        end
                        k = minimum([k, blocker[1]])
                    end
                end
                moving[col_moving[i]]=CartesianIndex(k - 1, col)
            end
        end

        # println("South")
        # print_stones(moving,blocking,n)
        sort!(moving)
        #East
        # sort!(moving,rev=true)
        for row ∈ 1:n
            row_moving = findall(x -> x[1] == row, moving)
            row_blocking = findall(x -> x[1] == row, blocking)
            for jj ∈ eachindex(row_moving)
                j = length(row_moving)-jj+1
                k = n+1
                if (j < length(row_moving))
                    k = moving[row_moving[j+1]][2]
                end
                if !isnothing(row_blocking)
                    for ll ∈ eachindex(row_blocking)
                        l = length(row_blocking)-ll+1
                        blocker = blocking[row_blocking[l]]
                        if blocker[2] < moving[row_moving[j]][2]
                            break
                        end
                        k = minimum([k, blocker[2]])
                    end
                end
                moving[row_moving[j]]=CartesianIndex(row,k - 1)
            end
        end
           
        if (mod(c, 1000000) == 0)
            print(c * 100 / n_cycles, "%")
        end
        # println("East")
        # print_stones(moving,blocking,n)
        # println("")
        sort!(moving)
        for l ∈ eachindex(history)
            if(history[l] == moving)
                period = c-l
                println("We have a periodicity with period ",period," at cycle ",c)
                print_stones(history[l],blocking,n)
                println("\n")
                print_stones(history[c-period],blocking,n)
                break
            end
        end
        if ( period != 0)
            l = c - period
            kk = mod(n_cycles-c,period)
            moving = history[l+kk]
            break
        end
        push!(history,deepcopy(moving))
    end
    println("")
    load::Int64 = 0
    for ind ∈ moving
        load += n - ind[1] + 1
    end
    return load
end

#read in information from file 
numlines = countlines(filename)

i::Int64 = 1
moving = Vector{CartesianIndex{2}}([])
blocking = Vector{CartesianIndex{2}}([])
open(filename) do file
    for l in eachline(file)
        arr = collect(l)
        for j ∈ eachindex(arr)
            if arr[j] == 'O'
                push!(moving, CartesianIndex(i, j))
            end
            if arr[j] == '#'
                push!(blocking, CartesianIndex(i, j))
            end
        end
        global i += 1
    end
end

# @time sol = move_cycles_and_calc_load(moving,blocking,numlines,10000) 
#0.816545 seconds (31.14 M allocations: 1.852 GiB, 18.59% gc time, 0.41% compilation time)
# @time sol = move_cycles_and_calc_load(moving,blocking,numlines,10000000)
# 1.401240 seconds (64.80 M allocations: 3.594 GiB, 27.84% gc time)
sol = move_cycles_and_calc_load(moving,blocking,numlines,1000000000)
# sol = move_cycles_and_calc_load(moving,blocking,numlines,4)
print("The solution is: ", sol, '\n')
