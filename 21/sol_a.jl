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

# filename::String = "21/testinput.txt"
filename::String = "21/input.txt"

numlines = countlines(filename)

current = fill(zero(Int8), numlines, numlines)
next = fill(zero(Int8), numlines, numlines)
stones = fill(zero(Int8), numlines, numlines)

function printplot(current::Matrix{Int8},stones::Matrix{Int8},n::Int64)
    for i ∈ 1:n
        for j ∈ 1:n
            if current[i,j] == 1
                if stones[i,j] == 1
                    print("X")
                else
                    print("O")
                end
            else
                if stones[i,j] ==1
                    print("#")
                else
                    print(".")
                end
            end
        end 
        println("")
    end
end 

i::Int64 = 1
open(filename) do file
    for l in eachline(file)
        chars = collect(l)
        for j ∈ eachindex(chars)
            if chars[j] == '#'
                global stones[i, j] = 1
            elseif chars[j] == 'S'
                global current[i, j] = 1
            end
        end
        global i += 1
    end
end

n = 64
for step ∈ 1:n
    for pos ∈ findall(x -> x == 1, current)
        local i = pos[1]
        j = pos[2]
        up = CartesianIndex(i-1,j)
        down = CartesianIndex(i+1,j)
        left = CartesianIndex(i,j-1)
        right = CartesianIndex(i,j+1)
        if i > 1 && stones[up]==0
            global next[up] = 1
        end
        if i < numlines && stones[down] == 0
            global next[down] = 1
        end
        if j > 1 && stones[left] == 0
            global next[left] = 1
        end
        if j < numlines && stones[right] == 0
            global next[right] =1
        end
    end
    global current = deepcopy(next)
    global next .= 0
end

sol = sum(current)
println("The solution is ", sol)