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


# filename::String = "19/testinput.txt"
filename::String = "19/input.txt"

using DataStructures

struct partset
    x::UnitRange{Int64}
    m::UnitRange{Int64}
    a::UnitRange{Int64}
    s::UnitRange{Int64}
    flow::String
end

struct cond
    category::Char
    less::Bool
    comparator::Int64
    dest::String
end

struct workflow
    comparisons::Vector{cond}
    altdest::String
end

workflows = Dict{String,workflow}()

# function split_partsets(psa::partset,psb::partset)

# end

open(filename) do file
    for l in eachline(file)
        if isempty(l)
            break
        end
        id, condstring = split(l, '{')
        conds = split(condstring, ',')
        comps = Vector{cond}([])
        for i ∈ 1:lastindex(conds)-1
            cat = conds[i][1]
            less = false
            if conds[i][2] == '<'
                less = true
            end
            comp = parse(Int64, conds[i][findfirst(r"\d+", conds[i])])
            stuff, dest = split(conds[i], ':')
            push!(comps, cond(cat, less, comp, string(dest)))
        end
        altdest = string(conds[end][1:end-1])
        global workflows =
            merge!(workflows,
                Dict{String,workflow}(string(id) => workflow(comps, string(altdest)))
            )
    end
end

sol::Int64 = 0

q = Queue{partset}()

enqueue!(q, partset(1:4000, 1:4000, 1:4000, 1:4000, "in"))
accepted = Vector{partset}([])
while !isempty(q)
    ps = dequeue!(q)
    if ps.flow == "R"
        continue
    elseif ps.flow == "A"
        push!(accepted,ps)
        continue
    end
    currflow = workflows[ps.flow]
    x = ps.x
    m = ps.m
    a = ps.a 
    s = ps.s
    println(ps.flow," ",x," ",m," ",a," ",s)
    for c ∈ currflow.comparisons
        if c.category == 'x'
            if c.less
                enqueue!(q,partset(x[1]:c.comparator-1,m,a,s,c.dest))
                x = c.comparator:x[end]
            else
                enqueue!(q,partset(c.comparator+1:x[end],m,a,s,c.dest))
                x = x[1]:c.comparator
            end
        elseif c.category == 'm'
            if c.less
                enqueue!(q,partset(x,m[1]:c.comparator-1,a,s,c.dest))
                m = c.comparator:m[end]
            else
                enqueue!(q,partset(x,c.comparator+1:m[end],a,s,c.dest))
                m = m[1]:c.comparator
            end
        elseif c.category == 'a'
            if c.less
                enqueue!(q,partset(x,m,a[1]:c.comparator-1,s,c.dest))
                a = c.comparator:a[end]
            else
                enqueue!(q,partset(x,m,c.comparator+1:a[end],s,c.dest))
                a = a[1]:c.comparator
            end
        else
            if c.less
                enqueue!(q,partset(x,m,a,s[1]:c.comparator-1,c.dest))
                s = c.comparator:s[end]
            else
                enqueue!(q,partset(x,m,a,c.comparator+1:s[end],c.dest))
                s = s[1]:c.comparator
            end
        end
    end
    enqueue!(q,partset(x,m,a,s,currflow.altdest))
end

for ps ∈ accepted
    global sol += length(ps.x)*length(ps.m)*length(ps.a)*length(ps.s) 
end
println("The solution is ", sol)