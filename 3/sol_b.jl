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




# filename::String = "3/testinput.txt"
filename::String = "3/input.txt"


mutable struct nums
    value::Int64
    i::Int64
    j::UnitRange{Int64}
    count::Bool
end

function count_gear_ratios(number_set::Vector{nums}, star_locations::Vector{Tuple{Int64,Int64}})
    ratios::BigInt = 0
    for (i, j) ∈ star_locations
        count::Int64 = 0 #How many number are adjacent?
        ratio::BigInt = 1 #What is the gear ratio, i.e. product of adjacent numbers
        for num ∈ number_set
            if( num.i < i-1 || num.i > i+1)
                continue
            end
            if( in((j-1),num.j) || in(j,num.j) || in((j+1),num.j) )
                count+=1
                ratio*=num.value
            end
        end
        # Star is only a gear if it has exactly two adjacent numbers
        if (count ==2)
            # If a star is a gear add the ratio to the total
            ratios+=ratio
        end
    end
    return ratios
end

number_set = Vector{nums}([])

star_locations = Vector{Tuple{Int64,Int64}}([])

i::Int64 = 1
#read in information from file (location of stars and numbers)
open(filename) do file
    for l in eachline(file)
        number_indices = findall(r"\d+", l)
        if (!isnothing(number_indices))
            for ran ∈ number_indices
                num = nums(parse(Int64, l[ran]), i, ran, false)
                push!(number_set, num)
            end
        end
        # find everything except for numbers, letters and .
        star_indices = findall('*', l)
        if (!isnothing(star_indices))
            for j ∈ star_indices
                push!(star_locations, (i, j))
            end
        end
        global i += 1
    end
end

sol = count_gear_ratios(number_set, star_locations)
print("The solution is: ",sol,'\n')
