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

current = Set{CartesianIndex{2}}()
next = Set{CartesianIndex{2}}()
stones = fill(zero(Int8), numlines, numlines)

i::Int64 = 1
open(filename) do file
    for l in eachline(file)
        chars = collect(l)
        for j ∈ eachindex(chars)
            if chars[j] == '#'
                global stones[i, j] = 1
            elseif chars[j] == 'S'
                push!(current, CartesianIndex(i, j))
            end
        end
        global i += 1
    end
end

n = 26501365
moddo = mod(n, 2)
nn = convert(Int64, floor(n / 100))
visited = Set{CartesianIndex{2}}()
for step ∈ 1:n
    for pos ∈ current
        local i = pos[1]
        j = pos[2]
        loop = false
        if mod(step, 2) == moddo
            loop = true
        end
        up = CartesianIndex(i - 1, j)
        ups = CartesianIndex(mod(i - 1 - 1, numlines) + 1, mod(j - 1, numlines) + 1)
        if (stones[ups] == 0)
            if loop
                if up ∉ visited 
                    push!(next,up)
                    push!(visited,up)
                end
            else
                push!(next, up)
            end
        end
        down = CartesianIndex(i + 1, j)
        downs = CartesianIndex(mod(i + 1 - 1, numlines) + 1, mod(j - 1, numlines) + 1)
        if (stones[downs] == 0)
            if loop
                if down ∉ visited
                    push!(next,down)
                    push!(visited,down)
                end
            else
                push!(next,down)
            end
        end
        left = CartesianIndex(i, j - 1)
        lefts = CartesianIndex(mod(i - 1, numlines) + 1, mod(j - 2, numlines) + 1)
        if (stones[lefts] == 0)
            if loop
                if left ∉ visited
                    push!(next,left)
                    push!(visited,left)
                end
            else
                push!(next,left)
            end
        end
        right = CartesianIndex(i, j + 1)
        rights = CartesianIndex(mod(i - 1, numlines) + 1, mod(j + 1 - 1, numlines) + 1)
        if (stones[rights] == 0)
            if loop
                if right ∉ visited
                    push!(next,right)
                    push!(visited,right)
                end
            else
                push!(next,right)
            end
        end
    end
    global current = next
    global next = Set{CartesianIndex{2}}()
end

sol = length(visited)
println("The solution is ", sol)