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




# filename::String = "10/testinput_b.txt"
# filename::String = "10/testinput_c.txt"
# filename::String = "10/testinput_d.txt"
filename::String = "10/input.txt"

numlines = countlines(filename)
numcols::Int64 = 0
open(filename) do file
    for l in eachline(file)
        v = collect(l)
        global numcols = length(v)
        break
    end
end

tube_layout = Matrix{Char}(undef, numlines, numcols)
dir_layout = fill(' ', numlines, numcols)
main_loop = fill(false, numlines, numcols)
insiders = fill(1, numlines, numcols)

function do_dir_step(tube_layout::Matrix{Char}, direction_layout::Matrix{Char}, ind::CartesianIndex, prev::CartesianIndex)
    diff = prev - ind
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
    if curr == '|' #vertical pipe
        if prevdir == 'N'
            return ind + CartesianIndex(1, 0), direction_layout[prev]
        else
            return ind + CartesianIndex(-1, 0), direction_layout[prev]
        end
    elseif curr == '-' #horizontal pipe
        if prevdir == 'E'
            return ind + CartesianIndex(0, -1), direction_layout[prev]
        else
            return ind + CartesianIndex(0, 1), direction_layout[prev]
        end
    elseif curr == 'L' #N-E bend
        if prevdir == 'N'
            newind = ind + CartesianIndex(0, 1)
            if direction_layout[prev] == 'l'
                return newind, 'd'
            else
                return newind, 'u'
            end
        else
            newind = ind + CartesianIndex(-1, 0)
            if direction_layout[prev] == 'u'
                return newind, 'r'
            else
                return newind, 'l'
            end
        end
    elseif curr == 'J' #N-W bend
        if prevdir == 'N'
            newind = ind + CartesianIndex(0, -1)
            if direction_layout[prev] == 'l'
                return newind, 'u'
            else
                return newind, 'd'
            end
        else
            newind = ind + CartesianIndex(-1, 0)
            if direction_layout[prev] == 'u'
                return newind, 'l'
            else
                return newind, 'd'
            end
        end
    elseif curr == '7' #S-W bend
        if prevdir == 'S'
            newind = ind + CartesianIndex(0, -1)
            if direction_layout[prev] == 'l'
                return newind, 'd'
            else
                return newind, 'u'
            end
        else
            newind = ind + CartesianIndex(1, 0)
            if direction_layout[prev] == 'd'
                return newind, 'l'
            else
                return newind, 'r'
            end
        end
    elseif curr == 'F' #S-E bend
        if prevdir == 'S'
            newind = ind + CartesianIndex(0, 1)
            if direction_layout[prev] == 'l'
                return newind, 'u'
            else
                return newind, 'd'
            end
        else
            newind = ind + CartesianIndex(1, 0)
            if direction_layout[prev] == 'u'
                return newind, 'l'
            else
                return newind, 'r'
            end
        end
    end
end

function find_start_neighbors(tube_layout::Matrix{Char}, startind::CartesianIndex)
    east = '.'
    west = '.'
    north = '.'
    south = '.'
    if startind[2] == size(tube_layout)[1]
        east = 'B'
    else
        east = tube_layout[startind+CartesianIndex(0, 1)]
    end
    if startind[2] == 1
        west = 'B'
    else
        west = tube_layout[startind+CartesianIndex(0, -1)]
    end
    if startind[1] == size(tube_layout)[2]
        south = 'B'
    else
        south = tube_layout[startind+CartesianIndex(1, 0)]
    end
    if startind[1] == 1
        north = 'B'
    else
        north = tube_layout[startind+CartesianIndex(-1, 0)]
    end
    if east == '-' || east == 'J' || east == '7'
        return CartesianIndex(startind[1], startind[2] + 1), 'd'
    end
    if west == '-' || west == 'L' || west == 'F'
        return CartesianIndex(startind[1], startind[2] - 1), 'u'
    end
    if north == '|' || north == 'F' || north == '7'
        return CartesianIndex(startind[1] - 1, startind[2]), 'l'
    end
    if south == '|' || south == 'L' || south == 'J'
        return CartesianIndex(startind[1] + 1, startind[2]), 'r'
    end
end
#read in information from file (location of stars and numbers)
i::Int64 = 1
startindex = CartesianIndex(1, 1)
open(filename) do file
    for l in eachline(file)
        v = collect(l)
        for j ∈ eachindex(v)
            tube_layout[i, j] = v[j]
            if (v[j] == 'S')
                global startindex = CartesianIndex(i, j)
            end
        end
        global i += 1
    end
end

neighbor1, startdir = find_start_neighbors(tube_layout, startindex)
dir_layout[startindex] = startdir
currind = neighbor1
prevind = startindex

while (currind != startindex)
    nextind, dir = do_dir_step(tube_layout, dir_layout, currind, prevind)
    dir_layout[currind] = dir
    # println(prevind, " ", tube_layout[currind], "(", currind[1], ",", currind[2], ") ", nextind)
    global main_loop[prevind] = true
    global prevind = currind
    global currind = nextind
    # global sol += 1
end
main_loop[prevind] = true

for i ∈ 1:size(tube_layout)[1]
    outside = true
    for j ∈ 1:size(tube_layout)[2]
        if dir_layout[i, j] == 'l' || dir_layout[i, j] == 'd' || dir_layout[i,j] == 'u'
            outside = false
        end
        if main_loop[i, j]
            insiders[i, j] = 0
        end
        if outside
            insiders[i, j] = 0
        end
    end
    outside = true
    j = size(tube_layout)[2]
    while (j > 0)
        if dir_layout[i, j] == 'd' || dir_layout[i, j] == 'u' || dir_layout[i, j] == 'r'
            outside = false
        end
        if outside
            insiders[i, j] = 0
        end
        j -= 1
    end
end

for j ∈ 1:size(tube_layout)[2]
    outside = true
    for i ∈ 1:size(tube_layout)[1]
        if dir_layout[i, j] == 'l' || dir_layout[i, j] == 'u'
            outside = false
        end
        if outside
            insiders[i, j] = 0
        end
    end
    outside = true
    local i = size(tube_layout)[1]
    while (i > 0)
        if dir_layout[i, j] == 'd' || dir_layout[i, j] == 'u' || dir_layout[i, j] == 'r'
            outside = false
        end
        if outside
            insiders[i, j] = 0
        end
        i -= 1
    end
end

for i ∈ 1:size(tube_layout)[1]
    for j ∈ 1:size(dir_layout)[2]
        if (insiders[i, j] > 0)
            #go down
            for k ∈ i+1:size(tube_layout)[1]
                if dir_layout[k, j] == 'u'
                    insiders[i, j] = 0
                    break
                end
                if dir_layout[k, j] == 'l' || dir_layout[k, j] == 'r' || dir_layout[k, j] == 'd'
                    break
                end
            end
            #go up
            k = i - 1
            while k > 0
                if dir_layout[k, j] == 'd'
                    insiders[i, j] = 0
                    break
                end
                if dir_layout[k, j] == 'l' || dir_layout[k, j] == 'r' || dir_layout[k, j] == 'u'
                    break
                end
                k -= 1
            end
            #go right
            for k ∈ j+1:size(tube_layout)[2]
                if dir_layout[i,k] == 'l'
                    insiders[i, j] = 0
                    break
                end
                if dir_layout[i,k] == 'r' || dir_layout[i,k] == 'u' || dir_layout[i,k] == 'd'
                    break
                end
            end
            #go left
            k = j - 1
            while k > 0
                if dir_layout[i, k] == 'r'
                    insiders[i, j] = 0
                    break
                end
                if dir_layout[i, k] == 'l' || dir_layout[i, k] == 'd' || dir_layout[i, k] == 'u'
                    break
                end
                k -= 1
            end
        end
    end
end


println(sum(insiders))