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

hightotal::Int64 = 0
lowtotal::Int64 = 0
n::Int64 = 1000
looped = false
highs = fill(zero(Int64),n)
lows = fill(one(Int64),n)
for i ∈ 1:n
    println("i = ",i)
    pulses = Queue{pulse}()
    for b ∈ broadcaster
        enqueue!(pulses, pulse(false, "broadcaster", b))
    end
    while !isempty(pulses)
        p = dequeue!(pulses)
        if p.high
            highs[i] += 1
            # println("high pulse from ",p.from," to ",p.dest," ",highs[i])
        else
            lows[i] += 1
            # println("low pulse from ",p.from," to ",p.dest," ",lows[i])
        end
        if p.dest ∈ keys(conjunctions)
            process_conjunction(conjunctions[p.dest],p,pulses)
        elseif p.dest ∈ keys(flipflops)
            process_flipflop(flipflops[p.dest],p,pulses)
        end
    end
    # Check state of everything
    all_low = true
    for ff ∈ values(flipflops)
        if ff.on
            all_low = false
            break
        end
    end
    if all_low
        for con ∈ values(conjunctions)
            for st ∈ con.states
                if st
                    all_low = false
                    break
                end
            end
            if !all_low
                break
            end
        end
    end
    
    if all_low
        println("loop found at ",i)
        kk = mod(n,i) #n = a*i+kk
        a = convert(Int64,floor(n/i))
        println(n," = ",a," * ",i," + ",kk)
        for j ∈ 1:i
            global hightotal+= a*highs[j]
            global lowtotal+= a*lows[j]
        end
        for j ∈ 1:kk
            global hightotal+= highs[j]
            global lowtotal += lows[j]
        end
        looped = true
        break
    end

end
if !looped
    global hightotal = sum(highs)
    global lowtotal = sum(lows)
end
println(hightotal," ",lowtotal)
sol = hightotal * lowtotal
println("The solution is ", sol)