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




# filename::String = "4/testinput.txt"
filename::String = "4/input.txt"

mutable struct card
    game::Int64
    copies::Int64
    winners::Vector{Int64}
    owned::Vector{Int64}
end


function process_cards(card_set::Vector{card})
    sum::Int64 = 0
    for card ∈ card_set
        sum+=card.copies
        num_winners::Int64 = 0
        for winner ∈ card.winners
            if winner ∈ card.owned
                num_winners += 1
            end
        end
        if (num_winners>0)
            minind = minimum((card.game+num_winners,length(card_set)))
            for i ∈ (card.game+1):minind
                card_set[i].copies+=card.copies
            end
        end
    end
    return sum
end

card_set = Vector{card}([])

#read in information from file (location of stars and numbers)
open(filename) do file
    for l in eachline(file)
        winners = Vector{Int64}([])
        owned = Vector{Int64}([])
        gamestring, numberstring = split(l, ':')
        game = parse(Int64, gamestring[findfirst(r"\d+", gamestring)])
        winnerstring, ownedstring = split(numberstring, '|')
        for ran ∈ findall(r"\d+", winnerstring)
            push!(winners, parse(Int64, winnerstring[ran]))
        end
        for ran ∈ findall(r"\d+", ownedstring)
            push!(owned, parse(Int64, ownedstring[ran]))
        end
        push!(card_set, card(game, 1, winners, owned))
    end
end
sol = process_cards(card_set)
print("The solution is: ",sol,'\n')
