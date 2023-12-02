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

# filename::String = "1/testinput2.txt"
filename::String = "1/input.txt"

function textindices(line::String,numstring::String)::Vector{Int64}
    ran = findfirst(numstring,line)
    inds = fill(500,2)
    if(!isnothing(ran))
        inds[1]=ran[1]
    end
    ran = findlast(numstring,line)
    if(!isnothing(ran))
        inds[2]=ran[1]
    else
        inds[2]=0
    end
    return inds
end

sol::Int64 = 0
open(filename) do file
    for l in eachline(file)
        indices = fill(500,10,2)
        firstnum::Int64 = 0
        indices[1,:] = textindices(l,"one")
        indices[2,:] = textindices(l,"two")
        indices[3,:] = textindices(l,"three")
        indices[4,:] = textindices(l,"four")
        indices[5,:] = textindices(l,"five")
        indices[6,:] = textindices(l,"six")
        indices[7,:] = textindices(l,"seven")
        indices[8,:] = textindices(l,"eight")
        indices[9,:] = textindices(l,"nine")

        ind = findfirst(x -> isnumeric(x),l)
        if(!isnothing(ind))
            firstnum = parse(Int64, l[ind])
            indices[10,1] = ind
        end
        ind = findlast(x -> isnumeric(x),l)
        if(!isnothing(ind))
            lastnum = parse(Int64, l[ind])
            indices[10,2] = ind
        else
            indices[10,2] = 0
        end
        
        minind=argmin(indices[:,1])
        if (minind==10)
            num = 10*firstnum
        else
            num = 10*minind
        end
        maxind=argmax(indices[:,2])
        if (maxind==10)
            num += lastnum
        else
            num += maxind
        end
        global sol += num
    end
end
print("The solution is: ", sol, '\n')
