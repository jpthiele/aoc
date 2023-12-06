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




# filename::String = "5/testinput.txt"
filename::String = "5/input.txt"

seeds = Vector{UnitRange{Int64}}([])
soils = Vector{UnitRange{Int64}}([])
fertilizers = Vector{UnitRange{Int64}}([])
waters = Vector{UnitRange{Int64}}([])
lights = Vector{UnitRange{Int64}}([])
temperatures = Vector{UnitRange{Int64}}([])
humidities = Vector{UnitRange{Int64}}([])
locations = Vector{UnitRange{Int64}}([])

function check_range(subrange::UnitRange{Int64},range::UnitRange{Int64})
    a = typemax(Int64)
    b = -1
    if(subrange[1]∈ range)
        a = subrange[1]
    elseif(range[1]∈ subrange)
        a = range[1]
    end
    if(subrange[end]∈ range)
        b = subrange[end]
    elseif(range[end]∈subrange)
        b = range[end]
    end
    return a,b
end

function map_matching(src::Vector{UnitRange{Int64}},dst::Vector{UnitRange{Int64}},line::String)
    i::Int8=0
    dst_range_start::Int64=0
    src_range_start::Int64=0
    range_length::Int64=0
    for ran ∈ findall(r"\d+",line)
        if(i==0)
            dst_range_start=parse(Int64,line[ran])+1
            i=1
        elseif (i==1)
            src_range_start=parse(Int64,line[ran])+1
            i=2
        else
            range_length=parse(Int64,line[ran])
        end
    end
    src_range=src_range_start:src_range_start+range_length-1
    to_rm = Vector{Int64}([])
    for i ∈ 1:length(src)
        ran = src[i]
        minnum,maxnum = check_range(src_range,ran)
        if(maxnum==-1)
            continue
        end
        if(minnum==typemax(Int64))
            continue
        end
        println(i,": ",src_range," ",ran," > ",minnum,":",maxnum)
        startdst = dst_range_start+minnum-src_range_start
        enddst = dst_range_start+maxnum-src_range_start
        push!(dst,startdst:enddst)

        begin_src_range = ran[1]:minnum-1
        end_src_range = maxnum+1:ran[end]
        if (ran[1]==minnum)
            if(ran[end]==maxnum)
                push!(to_rm,i)
            else
                src[i]=end_src_range
            end
        else
            src[i] = begin_src_range
            if(ran[end]!=maxnum)
                push!(src,end_src_range)
            end
        end
    end 
    while !isempty(to_rm)
        i= pop!(to_rm)
        deleteat!(src,i)
    end
end

function fill_missing(src::Vector{UnitRange{Int64}},dst::Vector{UnitRange{Int64}})
    for ran ∈ src
        push!(dst,ran)
    end
end


mode::Int16=0
seed_range_start::Int64=0
seed_range_length::Int64=0
seedmode::Int16=0
open(filename) do file
    for l in eachline(file)
        if(isempty(l))
            continue
        end
        if(isequal(l,"seed-to-soil map:"))
            println(l)
            global mode=1
            continue
        end
        if(isequal(l,"soil-to-fertilizer map:"))
            println(l)
            global mode=2
            fill_missing(seeds,soils)
            continue
        end
        if(isequal(l,"fertilizer-to-water map:"))
            println(l)
            global mode=3
            fill_missing(soils,fertilizers)
            println(fertilizers)
            continue
        end
        if(isequal(l,"water-to-light map:"))
            println(l)
            global mode=4
            fill_missing(fertilizers,waters)
            println(waters)
            continue
        end
        if(isequal(l,"light-to-temperature map:"))
            println(l)
            global mode=5
            fill_missing(waters,lights)
            println(lights)
            continue
        end
        if(isequal(l,"temperature-to-humidity map:"))
            println(l)
            global mode=6
            fill_missing(lights,temperatures)
            println(temperatures)
            continue
        end
        if(isequal(l,"humidity-to-location map:"))
            println(l)
            global mode=7
            fill_missing(temperatures,humidities)
            println(humidities)
            continue
        end

        if(mode==0)
            for ran ∈ findall(r"\d+",l)
                if(seedmode==0)
                    global seed_range_start=parse(Int64,l[ran])+1
                    global seedmode=1
                else
                    global seed_range_length=parse(Int64,l[ran])-1
                    push!(seeds,seed_range_start:seed_range_start+seed_range_length)    
                    global seedmode=0
                end
            end
            println(seeds)
        end
        if(mode==1)
            map_matching(seeds,soils,l)
            continue
        end
        if(mode==2)
            map_matching(soils,fertilizers,l)
            continue
        end
        if(mode==3)
            map_matching(fertilizers,waters,l)
            continue
        end
        if(mode==4)
            map_matching(waters,lights,l)
            continue
        end
        if(mode==5)
            map_matching(lights,temperatures,l)
            continue
        end
        if(mode==6)
            map_matching(temperatures,humidities,l)
            continue
        end
        if(mode==7)
            map_matching(humidities,locations,l)
        end
    end
end
fill_missing(humidities,locations)
println(locations)
print("The solution is: ",minimum(locations)[1]-1,'\n')
