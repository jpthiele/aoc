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




# filename::String = "9/testinput.txt"
filename::String = "9/input.txt"

function get_first_value(v::Vector{Int64})
    diffs =Vector{Int64}([])
    allzero::Bool=true
    for i∈ 1:length(v)-1
        push!(diffs,v[i+1]-v[i])
        if diffs[i]!=0
            allzero=false
        end
    end 
    if !allzero
        return v[1]-get_first_value(diffs)
    else
        return v[1]
    end
end
sol::Int64=0
#read in information from file (location of stars and numbers)
open(filename) do file
    for l in eachline(file)
        v = Vector{Int64}([])
        for ran ∈ findall(r"-?\d+",l)
            push!(v,parse(Int64,l[ran]))
        end
        global sol += get_first_value(v)
    end
end

print("The solution is: ",sol,'\n')
