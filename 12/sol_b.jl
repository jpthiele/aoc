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




filename::String = "12/testinput.txt"
# filename::String = "12/input.txt"

function check_string(str::String, counts::Vector{Int64})
    i::Int64 = 1
    for ran ∈ findall(r"#+", str)
        if (i > length(counts))
            return false
        end
        if (length(ran) != counts[i])
            return false
        end
        i += 1
    end
    if (i != length(counts) + 1)
        return false
    end
    return true
end

function replace_and_check(str::String, counts::Vector{Int64})
    count::Int64 = 0
    ind = findfirst(r"\?+", str)
    damvec = collect(str)
    opvec = collect(str)
    if(length(ind)>1)
        damopvec = collect(str)
        opdamvec = collect(str)
        i = ind[1]
        j = ind[2]
        damvec[i]='#'
        damopvec[i]='#'
        opvec[i]='.'
        opdamvec[i]='.'
        damvec[j]='#'
        opdamvec[j]='#'
        damopvec[j]='.'
        opvec[j]='.'
        damstring = join(damvec)
        if(isnothing(findfirst('?',damstring)))
            count+=check_string(damstring,counts)
            count+=check_string(join(damopvec),counts)
            count+=check_string(join(opdamvec),counts)
            count+=check_string(join(opvec),counts)
        else
            count+=replace_and_check(damstring,counts)
            count+=replace_and_check(join(damopvec),counts)
            count+=replace_and_check(join(opdamvec),counts)
            count+=replace_and_check(join(opvec),counts)
        end
    else
        damvec[ind[1]] = '#'
        opvec[ind[1]] = '.'
        damstring = join(damvec)
        if (isnothing(findfirst('?', damstring)))
            count += check_string(damstring, counts)
            count += check_string(join(opvec), counts)
        else
            count += replace_and_check(damstring, counts)
            count += replace_and_check(join(opvec), counts)
        end
    end
    return count
end

function combinations(line::String)
    gearstring, countstring = split(line)
    println(line)
    combo::Int64 = 0
    counts = Vector{Int64}([])
    gearstr = ""
    for i ∈ 1:5
        for ran ∈ findall(r"\d+", countstring)
            push!(counts, parse(Int64, countstring[ran]))
        end
        gearstr=string(gearstr,gearstring)
        if(i <5)
            gearstr=string(gearstr,"?")
        end
    end
    println(counts)
    println(gearstr)
    combo = replace_and_check(gearstr, counts)
    println(combo)
    return combo
end

#read in information from file (location of stars and numbers)
sol::Int64 = 0
open(filename) do file
    for l in eachline(file)
        global sol += combinations(l)
    end
end


print("The solution is: ", sol, '\n')
