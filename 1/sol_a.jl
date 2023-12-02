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

# filename::String = "1/testinput.txt"
filename::String = "1/input.txt"

sol::Int32 = 0
open(filename) do file
    for l in eachline(file)
        ind = findfirst(x -> isnumeric(x), l)
        num::Int32 = parse(Int8,l[ind])*10
        ind = findlast(x -> isnumeric(x),l)
        num::Int32 += parse(Int8,l[ind])
        # Check number search
        print(num,'\n')
        global sol+=num
    end
end
print("The solution is: ",sol,'\n')
