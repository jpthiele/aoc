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




# filename::String = "10/testinput.txt"
filename::String = "10/input.txt"

numlines = countlines(filename)

tube_layout = Matrix{Char}(undef,numlines,numlines)

function do_step(tube_layout::Matrix{Char},ind::CartesianIndex,prev::CartesianIndex)
    diff = prev-ind
    prevdir::Char = ' '
    if diff[2] == 1
        prevdir = 'E'
    elseif diff[2] == -1
        prevdir = 'W'
    elseif diff[1] == 1
        prevdir = 'S'
    else
        prevdir = 'N'
    end

    curr::Char = tube_layout[ind]
    if curr=='|' #vertical pipe
        if prevdir == 'N'
            return ind+CartesianIndex(1,0)
        else 
            return ind+CartesianIndex(-1,0)
        end
    elseif curr=='-' #horizontal pipe
        if prevdir == 'E'
            return ind+CartesianIndex(0,-1)
        else
            return ind+CartesianIndex(0,1)
        end
    elseif curr=='L' #N-E bend
        if prevdir == 'N'
            return ind+CartesianIndex(0,1)
        else
            return ind+CartesianIndex(-1,0)
        end
    elseif curr=='J' #N-W bend
        if prevdir == 'N'
            return ind+CartesianIndex(0,-1)
        else
            return ind+CartesianIndex(-1,0)
        end
    elseif curr=='7' #S-W bend
        if prevdir == 'S'
            return ind+CartesianIndex(0,-1)
        else
            return ind+CartesianIndex(1,0)
        end
    elseif curr=='F' #S-E bend
        if prevdir == 'S'
            return ind+CartesianIndex(0,1)
        else
            return ind+CartesianIndex(1,0)
        end
    end
end

function find_start_neighbors(tube_layout::Matrix{Char},startind::CartesianIndex)
    east = '.'
    west = '.'
    north = '.'
    south = '.'
    if startind[2]==size(tube_layout)[1]
        east = 'B'
    else
        east = tube_layout[startind+CartesianIndex(0,1)]
    end
    if startind[2]==1
        west = 'B'
    else
        west = tube_layout[startind+CartesianIndex(0,-1)]
    end
    if startind[1]==size(tube_layout)[2]
        south = 'B'
    else
        south = tube_layout[startind+CartesianIndex(1,0)]
    end
    if startind[1]==1
        north = 'B'
    else
        north = tube_layout[startind+CartesianIndex(-1,0)]
    end
    if east == '-' || east == 'J' || east == '7'
        return CartesianIndex(startind[1],startind[2]+1)
    end
    if west == '-' || west == 'L' || west == 'F'
        return CartesianIndex(startind[1],startind[2]-1)
    end
    if north == '|' || north == 'F' || north == '7'
        return CartesianIndex(startind[1]-1,startind[2])
    end
    if south == '|' || south == 'L' || south == 'J'
        return CartesianIndex(startind[1]+1,startind[2])
    end
end
#read in information from file (location of stars and numbers)
i::Int64=1
startindex = CartesianIndex(1,1)
open(filename) do file
    for l in eachline(file)
        v = collect(l)
        for j ∈ eachindex(v)
            tube_layout[i,j] = v[j]
            if(v[j]=='S')
                global startindex=CartesianIndex(i,j)
            end
        end
        global i+=1
    end
end

neighbor1= find_start_neighbors(tube_layout,startindex)

currind = neighbor1
prevind = startindex
sol::Int64 = 1


while(currind!=startindex)
    nextind = do_step(tube_layout,currind,prevind)
    println(prevind," ",tube_layout[currind],"(",currind[1],",",currind[2],") ",nextind)
    global prevind = currind
    global currind = nextind
    global sol+=1
    if tube_layout[currind] == 'S'
        break
    end
end

print("The solution is: ",convert(Int64,sol/2),'\n')
