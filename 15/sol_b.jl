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
    val::Int64 = 0
    chars = collect(step)
    for i ∈ eachindex(chars)
        val+=convert(Int64,chars[i])
        val*=17
        val = mod(val,256)
    end
    return val
end

mutable struct lens
    label::String
    focal::Int8
end

sol::Int64 = 0

boxes = Vector{Vector{lens}}(undef,256)
for i ∈ 1:256
    boxes[i] = Vector{lens}([])
end
open(filename) do file
    for l in eachline(file)
        steps = split(l,',')
        for step ∈ steps
            if !isempty(findall('-',step))
                label = split(string(step),'-')
                box = HASH(string(label[1]))+1
                boxes[box] = filter(x->x.label!=string(label[1]),boxes[box])
            else
                label,fstring = split(string(step),'=')
                focal::Int8 = parse(Int8,fstring)
                box = HASH(string(label))+1
                contained = false
                for i ∈ eachindex(boxes[box])
                    if boxes[box][i].label == string(label)
                        contained = true
                        boxes[box][i].focal = focal
                    end
                end
                if !contained
                    push!(boxes[box],lens(string(label),focal))
                end
            end
            global sol +=HASH(string(step))
        end 
    end
end

sol::Int64 = 0
for box ∈ eachindex(boxes)
    for slot ∈ eachindex(boxes[box])
        # println(box," (box) * ",slot, "(slot) * ",boxes[box][slot].focal," (focal length)")
        global sol+=box*slot*boxes[box][slot].focal
    end
end 

println("The solution is ",sol)