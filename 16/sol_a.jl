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




# filename::String = "16/testinput.txt"
filename::String = "16/input.txt"

mutable struct beam
    loc::CartesianIndex{2}
    dir::CartesianIndex{2}
end

numlines = countlines(filename)

mirrors = fill(' ', numlines, numlines)
i::Int64 = 1
open(filename) do file
    for l in eachline(file)
        mirrors[i, :] = collect(l)
        global i += 1
    end
end

beams = Vector{beam}([beam(CartesianIndex(1, 0), CartesianIndex(0, 1))])
heated = fill(zero(Int8), numlines, numlines)
dirs = Matrix{Vector{Bool}}(undef,numlines,numlines)
for ind ∈ eachindex(dirs)
    dirs[ind] = Vector{Bool}([false,false,false,false])
end
while !isempty(beams)
    #Always move first beam
    newloc = beams[1].loc + beams[1].dir
    # print(newloc)
    if newloc[1] < 1 || newloc[2] < 1 || newloc[1] > numlines || newloc[2] > numlines
        deleteat!(beams, 1)
    # println("")
        continue
    end
    heated[newloc] = 1
    beams[1].loc = newloc
    tile::Char = mirrors[newloc]
    # println(" ", tile)

    if (tile == '|' && beams[1].dir[2] != 0)
        beams[1].dir = CartesianIndex(-1, 0)
        push!(beams, beam(newloc, CartesianIndex(1, 0)))
    elseif (tile == '-' && beams[1].dir[1] != 0)
        beams[1].dir = CartesianIndex(0, -1)
        push!(beams, beam(newloc, CartesianIndex(0, 1)))
    elseif (tile == '/')
        if beams[1].dir[1] != 0
            beams[1].dir = CartesianIndex(0, -beams[1].dir[1])
        elseif beams[1].dir[2] != 0
            beams[1].dir = CartesianIndex(-beams[1].dir[2], 0)
        end
    elseif (tile == '\\')
        if beams[1].dir[1] != 0
            beams[1].dir = CartesianIndex(0, beams[1].dir[1])
        elseif beams[1].dir[2] != 0
            beams[1].dir = CartesianIndex(beams[1].dir[2], 0)
        end
    else #tile == .
        if beams[1].dir[1] == 1
            if dirs[newloc][1] 
                deleteat!(beams, 1)
                continue
            else
                dirs[newloc][1] = true
            end
        elseif beams[1].dir[1] == -1
            if dirs[newloc][2]
                deleteat!(beams, 1)
                continue
            else
               dirs[newloc][2] = true
            end
        elseif beams[1].dir[2] == 1
            if dirs[newloc][3]
                deleteat!(beams, 1)
                continue
            else
                dirs[newloc][3] = true
            end
        else
            if dirs[newloc][4]
                deleteat!(beams, 1)
                continue
            else
                dirs[newloc][4] = true
            end
        end
    end
end

sol = sum(heated)
println("The solution is ",sol)