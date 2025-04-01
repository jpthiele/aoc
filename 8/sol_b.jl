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


# filename::String = "8/testinput_b.txt"
filename::String = "8/input.txt"
mutable struct node
    ownlabel::String
    llabel::String
    rlabel::String
    lindex::Int64
    rindex::Int64
end

d = Dict{String,Int64}()
instructionlabels::String = ""
node_set = Vector{node}([])
mode::Int8 = 0
startindices = Vector{Int64}([])
endindices = Vector{Int64}([])
#read in information from file (location of stars and numbers)
open(filename) do file
    for l in eachline(file)
        if (mode == 0)
            global instructionlabels = l
            global mode = 1
            continue
        elseif (mode == 1)
            global mode = 2
            continue
        end
        push!(node_set, node(l[1:3], l[8:10], l[13:15], 0, 0))
        merge!(d, Dict(l[1:3] => length(node_set)))
        if (!isnothing(match(r"..A", l[1:3])))
            push!(startindices, length(node_set))
        end
        if (!isnothing(match(r"..Z", l[1:3])))
            push!(endindices, length(node_set))
        end
    end
end

for n ∈ node_set
    n.lindex = d[n.llabel]
    n.rindex = d[n.rlabel]
end
println("following instructions")

instructionindex::Int64 = 1
sol::Int64 = 0
println(instructionlabels)

steps = fill(zero(BigInt), length(startindices))
currentindices = deepcopy(startindices)
step::Int64 = 0
while (minimum(steps) == 0)
    for i ∈ eachindex(currentindices)
        if (steps[i] > 0)
            continue
        end
        for endindex ∈ endindices
            if currentindices[i] == endindex
                steps[i] = step
            end
        end
        label = node_set[currentindices[i]].ownlabel
        if (instructionlabels[instructionindex] == 'L')
            global currentindices[i] = node_set[currentindices[i]].lindex
        else
            global currentindices[i] = node_set[currentindices[i]].rindex
        end
    end
    global instructionindex += 1
    global step += 1
    if (instructionindex > length(instructionlabels))
        global instructionindex = 1
    end
end

primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 
          67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 
          139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 271]
factors = fill(zero(Int64), length(steps), length(primes))
for i ∈ eachindex(steps)
    println("step ", i, " ", steps[i])
    rem = steps[i]
    for j ∈ eachindex(primes)
        if rem == 0
            break
        end
        while mod(rem, primes[j]) == 0
            rem = convert(Int64, rem / primes[j])
            global factors[i, j] += 1
        end
    end
end
sol::Int64 = 1

for k ∈ eachindex(steps)
    check = 1
    for i ∈ eachindex(primes)
        for j ∈ 1:factors[k,i]
            check*=primes[i]
        end
    end
    if (check!=steps[k])
        println(check," and ",steps[k]," don't match!")
    end
end


for i ∈ eachindex(primes)
    for j ∈ 1:maximum(factors[:,i])
        global sol*=primes[i]
    end
end

println(sol)



