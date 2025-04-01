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


9
# filename::String = "19/testinput.txt"
filename::String = "19/input.txt"

struct part
    x::Int64
    m::Int64
    a::Int64
    s::Int64
end

struct cond
    category::Char
    less::Bool
    comparator::Int64
    dest::String
end

function parse_condition(p::part,c::cond)
    if c.category == 'x'
        if c.less
            return p.x < c.comparator
        else
            return p.x > c.comparator
        end
    elseif c.category == 'm'
        if c.less
            return p.m < c.comparator
        else
            return p.m > c.comparator
        end
    elseif c.category == 'a'
        if c.less
            return p.a < c.comparator
        else
            return p.a > c.comparator
        end
    else
        if c.less
            return p.s < c.comparator
        else
            return p.s > c.comparator
        end
    end
end

struct workflow
    comparisons::Vector{cond}
    altdest::String
end

workflows = Dict{String,workflow}()
parts = Vector{part}([])

mode::Int64 = 0
open(filename) do file
    for l in eachline(file)
        if isempty(l)
            global mode = 1
            continue
        end
        if mode == 0
            id,condstring = split(l,'{')
            conds = split(condstring,',')
            comps = Vector{cond}([])
            for i ∈ 1:lastindex(conds)-1
                cat = conds[i][1]
                less = false
                if conds[i][2] == '<'
                    less = true
                end
                comp = parse(Int64,conds[i][findfirst(r"\d+",conds[i])])
                stuff,dest = split(conds[i],':')
                push!(comps,cond(cat,less,comp,string(dest)))
            end
            altdest = string(conds[end][1:end-1])
            global workflows = 
                merge!(workflows,
                Dict{String,workflow}(string(id)=>workflow(comps,string(altdest)))
                )
        else
            numindices = findall(r"\d+",l)
            x = parse(Int64,l[numindices[1]])
            m = parse(Int64,l[numindices[2]])
            a = parse(Int64,l[numindices[3]])
            s = parse(Int64,l[numindices[4]])
            push!(parts,part(x,m,a,s))
        end
    end
end

sol::Int64 = 0
for p ∈ parts
    currflow = workflows["in"]
    println(p)
    print("in -> ")
    while(true)
        dest = ""
        for i ∈ eachindex(currflow.comparisons)
            if parse_condition(p,currflow.comparisons[i])
                dest = currflow.comparisons[i].dest
                break
            end
        end
        if isempty(dest)
            dest = currflow.altdest
        end
        if dest == "R"
            println("R")
            break
        elseif dest == "A"
            println("A")
            global sol+=p.x+p.m+p.a+p.s 
            break
        else
            print(dest," -> ")
            currflow = workflows[dest]
        end
    end
    println("")
end
println("The solution is ", sol)