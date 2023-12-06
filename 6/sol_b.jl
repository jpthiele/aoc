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




# filename::String = "6/testinput.txt"
filename::String = "6/input.txt"

function num_of_possible_strategies(duration::Int64,best::Int64)
    num::Int64 = 0
    for i ∈ 1:duration-1
        if i*(duration-i) > best
            num+=1
        end
    end
    return num
end

times = Vector{Int64}([])
durations = Vector{Int64}([])

mode::Int8 = 0
open(filename) do file
    for l in eachline(file)
        line = filter(x->!isspace(x),l)
        if(mode==0)
            for ran ∈ findall(r"\d+",line)
                push!(times,parse(Int64,line[ran]))
            end
            global mode = 1
        elseif(mode==1)
            for ran ∈ findall(r"\d+",line)
                push!(durations,parse(Int64,line[ran]))
            end
        end
    end
end
sol::Int64 = 1
for j ∈ 1:length(times)
   num = num_of_possible_strategies(times[j],durations[j])
   println(times[j]," ",durations[j]," ",num)
   global sol*= num
end
print("The solution is: ",sol,'\n')
