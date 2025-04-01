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




# filename::String = "15/testinput.txt"
filename::String = "15/input.txt"

function HASH(step::String)
    println(step)
    val::Int64 = 0
    chars = collect(step)
    for i ∈ eachindex(chars)
        val+=convert(Int64,chars[i])
        val*=17
        val = mod(val,256)
    end
    return val
end

sol::Int64 = 0
open(filename) do file
    for l in eachline(file)
        steps = split(l,',')
        for step ∈ steps
            global sol +=HASH(string(step))
        end 
    end
end

println("The solution is ",sol)