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




# filename::String = "17/testinput.txt"
filename::String = "17/input.txt"

using DataStructures

mutable struct path
    nodes::Vector{CartesianIndex{2}}
    heatloss::Int64
    dir::Int8
end

mutable struct step
    node::Vector{CartesianIndex{2}}
    dir::Int8
end

numlines = countlines(filename)

function Manhattan(x::CartesianIndex{2})
    return 2 * numlines - x[1] - x[2]
end
function Manhattan(x::path)
    return Manhattan(x.nodes[end])
end

function prio(x::path)::Int64
    return Manhattan(x) + x.heatloss
end

heatmap = fill(zero(Int64), numlines, numlines)
i::Int64 = 1
open(filename) do file
    for l in eachline(file)
        str = collect(l)
        for j ∈ eachindex(str)
            heatmap[i, j] = parse(Int64, str[j])
        end
        global i += 1
    end
end

visitedL = fill(typemax(Int64), numlines, numlines)
visitedR = fill(typemax(Int64), numlines, numlines)
visitedU = fill(typemax(Int64), numlines, numlines)
visitedD = fill(typemax(Int64), numlines, numlines)
# dirs right(1), down(2), left(-1), up(-2)

paths = PriorityQueue{path,Int64}()

pathone = path([CartesianIndex(1, 1)], 0, 1)
pathtwo = path([CartesianIndex(1, 1)], 0, 2)
prioone = prio(pathone)
priotwo = prio(pathtwo)
enqueue!(paths, pathone, prioone)
enqueue!(paths, pathtwo, priotwo)


sol::Int64 = 1330
# sol::Int64 = 120

while !isempty(paths)
    currpath = dequeue!(paths)
    currnode = currpath.nodes[end]

    if (currnode == CartesianIndex(numlines, numlines))
        global sol = min(sol, currpath.heatloss)
        rem = Vector{path}([])
        println("Solution updated: ", sol)
    end

    dir = currpath.dir
    loss = currpath.heatloss
    if mod(dir, 2) == 1
        if dir == 1
            if visitedR[currnode] < currpath.heatloss
                # println("There is a better way to ", currnode, " with ", visitedR[currnode], " < ", currpath.heatloss)
                # println("skipping")
                continue
            else
                visitedR[currnode] = currpath.heatloss
            end
        elseif dir == -1
            if visitedL[currnode] < currpath.heatloss
                # println("There is a better way to ", currnode, " with ", visitedL[currnode], " < ", currpath.heatloss)
                # println("skipping")
                continue
            else
                visitedL[currnode] = currpath.heatloss
            end
        end
        newloss = loss
        for k ∈ 1:3
            if currnode[1] - k < 1
                break
            end
            newnode = CartesianIndex(currnode[1] - k, currnode[2])
            newloss += heatmap[newnode]
            if (newloss + Manhattan(newnode) < sol)
                newnodes = deepcopy(currpath.nodes)
                push!(newnodes, newnode)
                newpath = path(newnodes, newloss, -2)
                enqueue!(paths, newpath, prio(newpath))
            end
        end
        newloss = loss
        for k ∈ 1:3
            if currnode[1] + k > numlines
                break
            end
            newnode = CartesianIndex(currnode[1] + k, currnode[2])
            newloss += heatmap[newnode]
            if (newloss + Manhattan(newnode) < sol)
                newnodes = deepcopy(currpath.nodes)
                push!(newnodes, newnode)
                newpath = path(newnodes, newloss, 2)
                enqueue!(paths, newpath, prio(newpath))
            end
        end
        visitedR[currnode] = true
    else
        if dir == 2
            if visitedD[currnode] < currpath.heatloss
                # println("There is a better way to ", currnode, " with ", visitedD[currnode], " < ", currpath.heatloss)
                # println("skipping")
                continue
            else
                visitedD[currnode] = currpath.heatloss
            end
        elseif dir == -2
            if visitedU[currnode] < currpath.heatloss
                # println("There is a better way to ", currnode, " with ", visitedU[currnode], " < ", currpath.heatloss)
                # println("skipping")
                continue
            else
                visitedU[currnode] = currpath.heatloss
            end
        end

        newloss = loss
        for k ∈ 1:3
            if currnode[2] - k < 1
                break
            end
            newnode = CartesianIndex(currnode[1], currnode[2] - k)
            newloss += heatmap[newnode]
            if (newloss + Manhattan(newnode) < sol)
                newnodes = deepcopy(currpath.nodes)
                push!(newnodes, newnode)
                newpath = path(newnodes, newloss, -1)
                enqueue!(paths, newpath, prio(newpath))
            end
        end
        newloss = loss
        for k ∈ 1:3
            if currnode[2] + k > numlines
                break
            end
            newnode = CartesianIndex(currnode[1], currnode[2] + k)
            newloss += heatmap[newnode]
            if (newloss + Manhattan(newnode) < sol)
                newnodes = deepcopy(currpath.nodes)
                push!(newnodes, newnode)
                newpath = path(newnodes, newloss, 1)
                enqueue!(paths, newpath, prio(newpath))
            end
        end
    end
end

println("The solution is ", sol)