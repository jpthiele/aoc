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

using DataStructures

# filename::String = "20/testinput.txt"
# filename::String = "20/testinput_b.txt"
filename::String = "20/input.txt"


struct pulse
    high::Bool
    from::String
    dest::String
end

mutable struct flipflop
    destinations::Vector{String}
    on::Bool
end

function process_flipflop(ff::flipflop, p::pulse, q::Queue{pulse})
    if !p.high
        ff.on = !ff.on
        for d ∈ ff.destinations
            enqueue!(q, pulse(ff.on, p.dest, d))
        end
    end
end

mutable struct conjunction
    inputs::Vector{String}
    states::Vector{Bool}
    destinations::Vector{String}
end

function process_conjunction(c::conjunction, p::pulse, q::Queue{pulse})
    allhigh = true
    for i ∈ eachindex(c.inputs)
        if c.inputs[i] == p.from
            c.states[i] = p.high
        end
        if !c.states[i]
            allhigh = false
        end
    end
    for d ∈ c.destinations
        enqueue!(q, pulse(!allhigh, p.dest, d))
    end
end

broadcaster = Vector{String}([])

flipflops = Dict{String,flipflop}()
conjunctions = Dict{String,conjunction}()

open(filename) do file
    for l in eachline(file)
        ff = findfirst(r"%[a-z]+", l)
        if isnothing(ff)
            con = findfirst(r"&[a-z]+", l)
            if isnothing(con)
                dstrings = split(l[15:end], ',')
                for d ∈ dstrings
                    push!(broadcaster, string(strip(d)))
                end
            else
                label = l[con[2]:con[end]]
                dstrings = split(l[con[end]+4:end], ',')
                dests = Vector{String}([])
                for d ∈ dstrings
                    push!(dests, string(strip(d)))
                end
                global conjunctions = merge!(conjunctions, Dict(label => conjunction(Vector{String}([]), Vector{Bool}([]), dests)))
            end
        else
            label = l[ff[2]:ff[end]]
            dstrings = split(l[ff[end]+4:end], ',')
            dests = Vector{String}([])
            for d ∈ dstrings
                push!(dests, string(strip(d)))
            end
            global flipflops = merge!(flipflops, Dict(label => flipflop(dests, false)))
        end
    end
end

for b ∈ broadcaster
    if b ∈ keys(conjunctions)
        push!(conjunctions[b].inputs, "broadcaster")
        push!(conjunctions[b].states, false)
    end
end

for ffpair ∈ flipflops
    for d ∈ ffpair[2].destinations
        if d ∈ keys(conjunctions)
            push!(conjunctions[d].inputs, ffpair[1])
            push!(conjunctions[d].states, false)
        end
    end
end

for conpair ∈ conjunctions
    for d ∈ conpair[2].destinations
        if d ∈ keys(conjunctions)
            push!(conjunctions[d].inputs, conpair[1])
            push!(conjunctions[d].states, false)
        end
    end
end

running = false
sol::Int64 = 0
i::Int64 = 0
loops = Vector{Int64}([])
labels = Vector{String}([])
for inp ∈ conjunctions["nc"].inputs
    push!(labels,inp)
    push!(loops,typemax(Int64))
end
while !running
    global i+=1
    # print(i,"..")
    pulses = Queue{pulse}()
    for b ∈ broadcaster
        enqueue!(pulses, pulse(false, "broadcaster", b))
    end
    while !isempty(pulses)
        p = dequeue!(pulses)
        if p.high && p.dest == "nc"
            for k ∈ eachindex(loops)
                if labels[k] == p.from
                    loops[k] = min(i,loops[k])
                end
            end
            if maximum(loops) < typemax(Int64)
                global sol = lcm(loops)
                global running = true
                break
            end 
        end
        if p.dest ∈ keys(conjunctions)
            process_conjunction(conjunctions[p.dest],p,pulses)
        elseif p.dest ∈ keys(flipflops)
            process_flipflop(flipflops[p.dest],p,pulses)
        end
    end
    if running
        break
    end
end
println("The solution is ", sol)