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
    value::Int64
    winners::Vector{Int64}
    owned::Vector{Int64}
end


function calculate_and_sum_values(card_set::Vector{card})
    sum::Int64 = 0
    for card ∈ card_set
        val::Int64 = 1
        for winner ∈ card.winners
            if winner ∈ card.owned
                val *= 2
            end
        end
        if (val == 1)
            card.value=0
        else
            card.value = val/2
            sum+=card.value
        end
        # println("Game ",card.game,": ",card.value)
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
        push!(card_set, card(game, 0, winners, owned))
    end
end
sol = calculate_and_sum_values(card_set)
print("The solution is: ",sol,'\n')
