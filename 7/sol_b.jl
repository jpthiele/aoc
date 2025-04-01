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




# filename::String = "7/testinput.txt"
filename::String = "7/input.txt"

mutable struct Card
    id::Char
end

mutable struct Hand
    bid::Int64
    type::Int8
    cards::Vector{Card}
end

function Base.show(io::IO,c::Card)
    print(io,c.id)
end
function Base.show(io::IO, h::Hand)
    typestring::String = ""
    if h.type == 0
        typestring = "HC"
    elseif h.type == 1
        typestring = "1P"
    elseif h.type == 2
        typestring = "2P"
    elseif h.type == 3
        typestring = "3K"
    elseif h.type == 4
        typestring = "FH"
    elseif h.type == 5
        typestring = "4K"
    elseif h.type == 6
        typestring = "5K"
    end
    cardstring = join(h.cards)
    print(io, "Hand(", cardstring, "(", typestring, ") ", h.bid, ")")
end

function Base.isequal(x::Card,y::Card)
    return isequal(x.id,y.id)
end

function Base.isless(x::Card,y::Card)
    if x.id ==y.id
        return false
    end
    if x.id == 'J'
        return true
    end
    if y.id == 'J'
        return false
    end
    if isnumeric(x.id)
        if isnumeric(y.id)
            return x.id < y.id
        end
        return true
    end
    if isnumeric(y.id)
       return false
    end
    # Basically game of chicken
    for c ∈ ['T','Q','K','A']
        if x.id == c
            return true
        end
        if y.id == c
            return false
        end
    end
end

function Base.isless(x::Hand, y::Hand)
    if (x.type < y.type)
        return true
    end
    if (x.type == y.type)
        for i ∈ 1:5
            if (x.cards[i] < y.cards[i])
                return true
            elseif(x.cards[i]>y.cards[i])
                return false
            end
        end
    end
    return false
end
function Base.isequal(x::Hand, y::Hand)
    if (x.cards != y.cards)
        return false
    end
    if (x.bid != y.bid)
        return false
    end
    return true
end
function get_hand_type(cardstring::String)::Int8
    uniquecards = Set(cardstring)
    if (!contains(cardstring,'J'))
        cardchars = Vector{Char}(cardstring)
        return get_hand_type(cardchars,uniquecards)
    end
    type::Int8 = 0
    # Special case five of a kind JJJJJ
    if(length(uniquecards)==1)
        return 6
    end
    for uc ∈ uniquecards
        if uc == 'J'
            continue
        end
        ht = get_hand_type(replace(cardstring,"J"=>uc))
        if (ht > type)
            type = ht
        end
    end 
    return type
end
function get_hand_type(cardchars::Vector{Char},uniquecards::Set{Char})::Int8
    type::Int8 = 0
    if (length(uniquecards) < 5) #at least one pair
        if (length(uniquecards) == 4)
            type = 1 #one pair
        elseif (length(uniquecards) == 1)
            type = 6 #five of a kind
        else #other types need counts for each unique card
            counts = fill(zero(Int8), length(uniquecards))
            i::Int64 = 1
            for uc ∈ uniquecards
                for c ∈ cardchars
                    if uc == c
                        counts[i] += 1
                    end
                end
                i += 1
            end
            sort!(counts)
            if (length(uniquecards) == 3)
                if (counts[2] == 2)
                    type = 2 #two pair
                else
                    type = 3 #three of a kind
                end
            else #2 unique cards
                if (counts[1] == 2)
                    type = 4 #Full House
                else
                    type = 5 #Five of a kind
                end
            end
        end
    end
    return type
end
function parse_hand(line::String)::Hand
    cardstring, bidstring = split(line)
    bid = parse(Int64, bidstring)
    cards = Vector{Card}([])
    for cc ∈ Vector{Char}(cardstring)
        push!(cards,Card(cc))
    end

    type = get_hand_type(String(cardstring))
    return Hand(bid, type, cards)
end

hand_set = Vector{Hand}([])

#read in information from file (location of stars and numbers)
open(filename) do file
    for l in eachline(file)
        push!(hand_set, parse_hand(l))
    end
end

sort!(hand_set)
for h ∈ hand_set
    println(h)
end
sol::BigInt=0
for i ∈ 1:length(hand_set)
    global sol+= hand_set[i].bid*i
end
print("The solution is: ",sol,'\n')
