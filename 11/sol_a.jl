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




# filename::String = "11/testinput.txt"
filename::String = "11/input.txt"

galaxies = Vector{CartesianIndex}([])

#read in information from file (location of stars and numbers)
i::Int64 = 1
emptycols = Vector{Bool}([])
open(filename) do file
    for l in eachline(file)
        if i==1
        global emptycols = fill(true,length(l))
        end
        indices = findall('#',l)
        if(isempty(indices))
            global i+=1
        else
            for j ∈ indices
                global emptycols[j] = false
                push!(galaxies,CartesianIndex(i,j))
            end
        end
        global i+=1
    end
end
emptycolindices = Vector{Int64}([])
for i∈ eachindex(emptycols)
    if emptycols[i]
        push!(emptycolindices,i)
    end
end
for i ∈ eachindex(galaxies)  
    if galaxies[i][2] < emptycols[1]
        continue
    end
    offset::Int64 = 0
    for col ∈ emptycolindices
        if galaxies[i][2] > col 
            offset += 1
        else
            break
        end
    end
    galaxies[i] = CartesianIndex(galaxies[i][1],galaxies[i][2]+offset)
end
sol::Int64 = 0
for i ∈ 1:length(galaxies)-1
    for j ∈ i+1:length(galaxies)
        diff =abs(galaxies[i][1]-galaxies[j][1])+abs(galaxies[i][2]-galaxies[j][2])
        global sol += diff
    end
end


print("The solution is: ",sol,'\n')
