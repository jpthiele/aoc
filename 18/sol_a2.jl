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




filename::String = "18/testinput.txt"
filename::String = "18/input.txt"

struct Vertex2D
    x::BigInt
    y::BigInt
end

function Manhattan(a::Vertex2D,b::Vertex2D)
    res::Int64 = 0
    res += abs(a.x-b.x)
    res += abs(a.y-b.y)
    return res
end

start = Vertex2D(1,1)
vertices = fill(start,1)
i::Int64 = 1
open(filename) do file
    for l in eachline(file)
        dir, numstring, colorstring = split(l)
        num = parse(BigInt,numstring)
        if dir == "R" 
            next = Vertex2D(vertices[i].x+num,vertices[i].y)
            println("R ",num,": ",next)
            push!(vertices,next)
        elseif dir == "L"
           next = Vertex2D(vertices[i].x-num,vertices[i].y)
           println("L ",num,": ",next)
           push!(vertices,next)
        elseif dir == "D"
            next = Vertex2D(vertices[i].x,vertices[i].y-num)
            println("D ",num,": ",next)
            push!(vertices,next)
        elseif dir == "U"
            next = Vertex2D(vertices[i].x,vertices[i].y+num)
            println("U ",num,": ",next)
            push!(vertices,next)
        end
        global i+=1
    end
end
# push!(vertices,start)
m = lastindex(vertices)
sol::BigInt = +vertices[m].x*vertices[1].y
sol-=vertices[1].x*vertices[m].y
# println(sol)
# Shoelace algorithm
for k ∈ eachindex(vertices)
    if k == 1
        continue
    end
    global sol += vertices[k].x*vertices[k-1].y
    global sol -= vertices[k-1].x*vertices[k].y
    # println(sol)
end
# Perimeter
for k ∈ eachindex(vertices)
    if k == m
        global sol+= Manhattan(vertices[k],vertices[1])
        break
    end
    global sol+=Manhattan(vertices[k],vertices[k+1])
end
# println(vertices)


println("The solution is ",convert(Int64,abs(sol)/2)+1)