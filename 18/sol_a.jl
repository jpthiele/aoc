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




# filename::String = "18/testinput.txt"
filename::String = "18/input.txt"

function print_digsite(dug::Matrix{Int8}, min_i::Int64, max_i::Int64, min_j::Int64, max_j::Int64)
    for i ∈ min_i:max_i
        for j ∈ min_j:max_j
            if (dug[i, j] == 1)
                print("#")
            else
                print(".")
            end
        end
        println("")
    end
end
function print_pointers(pointers::Matrix{Char}, min_i::Int64, max_i::Int64, min_j::Int64, max_j::Int64)
    for i ∈ min_i:max_i
        for j ∈ min_j:max_j
            if (pointers[i, j] == ' ')
                print(".")
            else
                print(pointers[i, j])
            end
        end
        println("")
    end
end
n = 500
dug = fill(zero(Int8), 2n, 2n)
inside = fill(one(Int8), 2n, 2n)
pointers = fill(' ', 2n, 2n)
min_i::Int64 = 2n
min_j::Int64 = 2n
max_i::Int64 = 1
max_j::Int64 = 1
current = CartesianIndex(n, n)
currpointer = ' '
lastdir = ""
open(filename) do file
    for l in eachline(file)
        dir, numstring, colorstring = split(l)
        num = parse(Int64, numstring)
        global currpointer = pointers[current]
        if currpointer == ' '
            global currpointer = 'L'
            global lastdir = "U"
        end
        if dir == "R"
            step = CartesianIndex(0, 1)
            steppointer = 'U'
            if (currpointer == 'R' && lastdir == "U") || (currpointer == 'L' && lastdir == "D")
                steppointer = 'D'
            end
            for i ∈ 1:num
                global current += step
                dug[current] = 1
                pointers[current] = steppointer
            end
            global max_j = max(max_j, current[2])
            global lastdir = dir
        elseif dir == "L"
            step = CartesianIndex(0, -1)
            steppointer = 'D'
            if (currpointer == 'L' && lastdir == "D") || (currpointer == 'R' && lastdir == "U")
                steppointer = 'U'
            end
            for i ∈ 1:num
                global current += step
                dug[current] = 1
                pointers[current] = steppointer
            end
            global min_j = min(min_j, current[2])
            global lastdir = dir
        elseif dir == "D"
            step = CartesianIndex(1, 0)
            steppointer = 'R'
            if (currpointer == 'D' && lastdir == "R") || (currpointer == 'U' && lastdir == "L")
                steppointer = 'L'
            end
            for i ∈ 1:num
                global current += step
                dug[current] = 1
                pointers[current] = steppointer
            end
            global max_i = max(max_i, current[1])
            global lastdir = dir
        elseif dir == "U"
            step = CartesianIndex(-1, 0)
            stepppointer = 'L'
            if (currpointer == 'D' && lastdir == "L") || (currpointer == 'U' && lastdir == "R")
                steppointer = 'L'
            end
            for i ∈ 1:num
                global current += step
                dug[current] = 1
                pointers[current] = steppointer
            end
            global min_i = min(min_i, current[1])
            global lastdir = dir
        end
    end
end


println(sum(dug))
println(min_i, ":", max_i, ",", min_j, ":", max_j)

println("filling")
inside -= dug
println("lr")
for i ∈ min_i:max_i
    for j ∈ min_j:max_j
        if dug[i, j] == 1
            break
        else
            inside[i, j] = 0
        end
    end
    for j ∈ max_j:-1:min_j
        if dug[i, j] == 1
            break
        else
            inside[i, j] = 0
        end
    end
end
for j ∈ min_j:max_j
    for i ∈ min_i:max_i
        if dug[i, j] == 1
            break
        else
            inside[i, j] = 0
        end
    end
    for i ∈ max_i:-1:min_i
        if dug[i, j] == 1
            break
        else
            inside[i, j] = 0
        end
    end
end

for i ∈ min_i:max_i
    for j ∈ min_j:max_j
        if inside[i, j] == 0
            continue
        end
        #go down
        for k ∈ i+1:max_i
            if pointers[k, j] == 'U'
                inside[i, j] = 0
                break
            end
            if pointers[k, j] == 'L' || pointers[k, j] == 'R' || pointers[k, j] == 'D'
                break
            end
        end
        #go u
        k = i - 1
        while k > min_i
            if pointers[k, j] == 'D'
                inside[i, j] = 0
                break
            end
            if pointers[k, j] == 'L' || pointers[k, j] == 'R' || pointers[k, j] == 'U'
                break
            end
            k -= 1
        end
        #go right
        for k ∈ j+1:max_j
            if pointers[i, k] == 'L'
                inside[i, j] = 0
                break
            end
            if pointers[i, k] == 'R' || pointers[i, k] == 'U' || pointers[i, k] == 'D'
                break
            end
        end
        #go left
        k = j - 1
        while k > min_j
            if pointers[i, k] == 'R'
                inside[i, j] = 0
                break
            end
            if pointers[i, k] == 'L' || pointers[i, k] == 'D' || pointers[i, k] == 'U'
                break
            end
            k -= 1
        end
    end
end



println("The solution is ", sum(dug) + sum(inside[min_i:max_i, min_j:max_j]))