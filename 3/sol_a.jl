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

function mark_numbers(number_set::Vector{nums}, special_char_locations::Vector{Tuple{Int64,Int64}})
    for (i, j) ∈ special_char_locations
        for num ∈ number_set
            if( num.i < i-1 || num.i > i+1)
                continue
            end
            if( in((j-1),num.j) || in(j,num.j) || in((j+1),num.j) )
                num.count = true
            end
        end
    end
end

function count_numbers(number_set::Vector{nums})
    count::Int64=0
    for num ∈ number_set
        if(num.count)
            count+= num.value
        end
    end
    return count
end

number_set = Vector{nums}([])

special_char_locations = Vector{Tuple{Int64,Int64}}([])

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
        star_indices = findall(r"[^A-Za-z0-9.]", l)
        if (!isnothing(star_indices))
            for ran ∈ star_indices
                for j ∈ ran
                    push!(special_char_locations, (i, j))
                end
            end
        end
        global i += 1
    end
end

mark_numbers(number_set, special_char_locations)
sol = count_numbers(number_set)
print("The solution is: ",sol,'\n')
