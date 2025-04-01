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




# filename::String = "8/testinput.txt"
filename::String = "8/input.txt"

mutable struct node
    ownlabel::String
    llabel::String
    rlabel::String
    lindex::Int64
    rindex::Int64
end

d = Dict{String,Int64}()
instructionlabels::String=""
node_set = Vector{node}([])
mode::Int8 = 0
#read in information from file (location of stars and numbers)
open(filename) do file
    for l in eachline(file)
        if (mode==0)
            global instructionlabels=l
            global mode=1
            continue
        elseif (mode==1)
            global mode=2
            continue
        end 
        push!(node_set,node(l[1:3],l[8:10],l[13:15],0,0)) 
        merge!(d,Dict(l[1:3]=>length(node_set)))
    end
end

zindex::Int64=d["ZZZ"]
for n ∈ node_set
    n.lindex = d[n.llabel]
    n.rindex = d[n.rlabel]
end
println("following instructions")
currindex::Int64 = d["AAA"]
instructionindex::Int64=1
sol::Int64 = 0
println(instructionlabels)
while (currindex!=zindex)
    label = node_set[currindex].ownlabel
    if (instructionlabels[instructionindex]=='L')
        global currindex = node_set[currindex].lindex
    else
        global currindex = node_set[currindex].rindex
    end
    println(label,":",instructionlabels[instructionindex],node_set[currindex])
    global instructionindex+=1
    global sol+=1
    if(instructionindex>length(instructionlabels))
        global instructionindex = 1
    end
end
print("The solution is: ",sol,'\n')
