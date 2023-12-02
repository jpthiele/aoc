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

# Check if a game is possible for a certain color by 
# finding all numbers of drawn cubes.
# The game is not possible if the number of cubes is higher than the maximum. 
function gamepossible(line::String,pattern::Regex,max::Int64)::Bool
    strings = findall(pattern,line)
    if(isnothing(strings))
        return true
    else
        for ran ∈ strings
            numran = findfirst(r"\d+",line[ran])
            num = parse(Int64,line[ran[numran]])
            if num > max
                return false
            end
        end
    end
    return true
end

# filename::String = "2/testinput.txt"
filename::String = "2/input.txt"

# Go over all lines in the input file 
# and check all three colors.
# The game was only possible if it is for each color.
sol::Int32 = 0
open(filename) do file
    for l in eachline(file)
        gameran = findfirst(r"Game \d+", l)
        game = parse(Int64,l[6:gameran[end]])
        red = gamepossible(l,r"\d+ red",12)
        green = gamepossible(l,r"\d+ green",13)
        blue = gamepossible(l,r"\d+ blue",14)
        if(red && green && blue)
            global sol += game
        end
    end
end
print("The solution is: ",sol,'\n')
