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

seeds = Vector{Int64}([])
soils = Vector{Int64}([])
fertilizers = Vector{Int64}([])
waters = Vector{Int64}([])
lights = Vector{Int64}([])
temperatures = Vector{Int64}([])
humidities = Vector{Int64}([])
locations = Vector{Int64}([])

function map_matching(src::Vector{Int64},dst::Vector{Int64},line::String)
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
    for i ∈ 1:length(src)
        if (src[i] ∈ src_range)
            dst[i] = dst_range_start+(src[i]-src_range_start)
        end
    end 
end

function fill_missing(src::Vector{Int64},dst::Vector{Int64})
    for i ∈ 1:length(src)
        if(dst[i]==0)
            dst[i]=src[i]
        end
    end
end
mode::Int16=0
open(filename) do file
    for l in eachline(file)
        if(isempty(l))
            continue
        end
        if(isequal(l,"seed-to-soil map:"))
            global mode=1
            continue
        end
        if(isequal(l,"soil-to-fertilizer map:"))
            global mode=2
            fill_missing(seeds,soils)
            continue
        end
        if(isequal(l,"fertilizer-to-water map:"))
            global mode=3
            fill_missing(soils,fertilizers)
            continue
        end
        if(isequal(l,"water-to-light map:"))
            global mode=4
            fill_missing(fertilizers,waters)
            continue
        end
        if(isequal(l,"light-to-temperature map:"))
            global mode=5
            fill_missing(waters,lights)
            continue
        end
        if(isequal(l,"temperature-to-humidity map:"))
            global mode=6
            fill_missing(lights,temperatures)
            continue
        end
        if(isequal(l,"humidity-to-location map:"))
            global mode=7
            fill_missing(temperatures,humidities)
            continue
        end

        if(mode==0)
            for ran ∈ findall(r"\d+",l)
                push!(seeds,parse(Int64,l[ran])+1)
            end
            global soils        = fill(Int64(0),length(seeds))
            global fertilizers  = fill(Int64(0),length(seeds))
            global waters       = fill(Int64(0),length(seeds))
            global lights       = fill(Int64(0),length(seeds))
            global temperatures = fill(Int64(0),length(seeds))
            global humidities   = fill(Int64(0),length(seeds))
            global locations    = fill(Int64(0),length(seeds))
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
print("The solution is: ",minimum(locations)-1,'\n')
