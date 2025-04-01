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
function print_stones(mat::Matrix{Int8}, blocking::Vector{CartesianIndex{2}})
    n = size(mat)[1]
    for row ∈ 1:n
        for col ∈ 1:n
            if mat[row, col] == 1
                print('O')
                continue
            end
            printed = false
            if (!printed)
                for block ∈ blocking
                    if (block == CartesianIndex(row, col))
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
    println("\n")
end

function move_cycles_and_calc_load(stones::Matrix{Int8},
    blocking::Vector{CartesianIndex{2}},
    n_cycles::Int64)
    n = size(stones)[1]
    row_blocking = Vector{Vector{Int64}}(undef, n)
    col_blocking = Vector{Vector{Int64}}(undef, n)
    for k ∈ 1:n
        row_blocking[k] = Int64[]
        col_blocking[k] = Int64[]
    end
    for stone ∈ blocking
        push!(row_blocking[stone[1]], stone[2])
        push!(col_blocking[stone[2]], stone[1])
    end
    col_blocking_rev = deepcopy(col_blocking)
    row_blocking_rev = deepcopy(row_blocking)
    for i ∈ 1:n
        sort!(col_blocking_rev[i], rev=true)
        sort!(row_blocking_rev[i], rev=true)
        push!(col_blocking[i], n + 1)
        push!(row_blocking[i], n + 1)
        push!(col_blocking_rev[i], 0)
        push!(row_blocking_rev[i], 0)
    end

    print_stones(stones, blocking)

    for c ∈ 1:n_cycles
        # North

        for j ∈ 1:n
            k::Int64 = 1
            for kk ∈ col_blocking[j]
                inds = findall(x -> x == 1, stones[k:(kk-1), j])
                for ll ∈ inds
                    stones[k+ll-1, j] = 0
                end
                stones[k:k+length(inds)-1, j] = broadcast(x -> x = 1, stones[k:k+length(inds)-1, j])
                k = kk + 1
            end
        end

        for i ∈ 1:n
            k::Int64 = 1
            for kk ∈ row_blocking[i]
                inds = findall(x -> x == 1, stones[i, k:(kk-1)])
                for ll ∈ inds
                    stones[i, k+ll-1] = 0
                end
                stones[i, k:k+length(inds)-1] = broadcast(x -> x = 1, stones[i, k:k+length(inds)-1])
                k = kk + 1
            end
        end

        for j ∈ 1:n
            k::Int64 = n
            for kk ∈ col_blocking_rev[j]
                inds = findall(x -> x == 1, stones[kk+1:k, j])
                for ll ∈ inds
                    stones[kk+ll, j] = 0
                end
                stones[k-length(inds)+1:k, j] = broadcast(x -> x = 1, stones[k-length(inds)+1:k, j])
                k = kk - 1
            end
        end

        for i ∈ 1:n
            k::Int64 = n
            for kk ∈ row_blocking_rev[i]
                inds = findall(x -> x == 1, stones[i,kk+1:k])
                for ll ∈ inds
                    stones[i,kk+ll] = 0
                end
                stones[i,k-length(inds)+1:k] = broadcast(x -> x = 1, stones[i,k-length(inds)+1:k])
                k = kk - 1
            end
        end
        # print_stones(stones, blocking)
        if (mod(c, 10000000) == 0)
            print(c * 100 / n_cycles, "%")
        end
    end
    # println("")
    load::Int64 = 0
    for i ∈ 1:n
        load += (n-i)*sum(mat[i,:])
    end 
    return load
end

#read in information from file 
numlines = countlines(filename)

i::Int64 = 1
blocking = Vector{CartesianIndex{2}}([])
mat = fill(zero(Int8), numlines, numlines)
open(filename) do file
    for l in eachline(file)
        arr = collect(l)
        for j ∈ eachindex(arr)
            if arr[j] == 'O'
                mat[i, j] = 1
            end
            if arr[j] == '#'
                push!(blocking, CartesianIndex(i, j))
            end
        end
        global i += 1
    end
end
@time sol = move_cycles_and_calc_load(mat,blocking,100000)
# 1.401240 seconds (64.80 M allocations: 3.594 GiB, 27.84% gc time)
# sol = move_cycles_and_calc_load(mat, blocking, 3)
print("The solution is: ", sol, '\n')
