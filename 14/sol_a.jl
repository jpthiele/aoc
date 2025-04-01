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




filename::String = "14/testinput.txt"
# filename::String = "14/input.txt"

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
function move_north_and_calc_load(
    moving::Vector{CartesianIndex{2}}, 
    blocking::Vector{CartesianIndex{2}}, 
    n::Int64)

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
sort!(moving)
sort!(blocking)
sol = move_north_and_calc_load(moving, blocking, numlines)
print_stones(moving,blocking,numlines)
print("The solution is: ", sol, '\n')
