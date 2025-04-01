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




# filename::String = "13/testinput.txt"
filename::String = "13/input.txt"

function analyze_pattern(pattern::Matrix{Int64})
    m = size(pattern)[1]
    smudges = 0
    # horizontal mirrors
    for i ∈ 1:m-1
        # check if no mirroring occurs 
        # between this column and the next
        smudges = sum(broadcast(abs,(pattern[i, :] - pattern[i+1, :])))
        if smudges >1
            continue
        end

        # check if we really have mirroring all the way to the edge?
        mirrroring::Bool = true
        for j ∈ 1:minimum([i - 1, m - i - 1])
            smudges += sum(broadcast(abs,(pattern[i-j, :] - pattern[i+j+1, :])))
            if smudges > 1
                mirrroring = false
                break
            end
        end
        if mirrroring && smudges == 1
            return i
        end
    end
    return 0
end

#read in information from file 
pattern = Matrix{Int64}(undef, 0, 0)
mode::Int64 = 0
global sol = 0
open(filename) do file
    for l in eachline(file)
        if l == ""
            pat = 100*analyze_pattern(pattern)
            if pat == 0
                pat = analyze_pattern(permutedims(pattern))
            end
            println("pattern solution=", pat)
            global sol += pat
            global mode = 0
            continue
        end
        arr = collect(l)
        if (mode == 0)
            global pattern = Matrix{Int64}(undef, 0, length(l))
            global mode = 1
        end
        x = fill(zero(Int64), 1, length(l))
        for i ∈ eachindex(arr)
            if arr[i] == '#'
                x[1, i] = 1
            end
        end
        global pattern = [pattern; x]
    end
end

pat = 100*analyze_pattern(pattern)
if pat == 0
    pat = analyze_pattern(permutedims(pattern))
end
println("pattern solution=", pat)
global sol += pat

print("The solution is: ", sol, '\n')
