# Copyright (C) 2022-2023 by Jan Philipp Thiele
#                                                                            
# This file is part of 22_awk
#                                                                            
# 22_awk is free software: you can redistribute it and/or modify  
# it under the terms of the GNU General Public License as          
# published by the Free Software Foundation, either                      
# version 3 of the License, or (at your option) any later version.          
#                                                                          
# 22_awk is distributed in the hope that it will be useful,       
# but WITHOUT ANY WARRANTY; without even the implied warranty of            
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.                       
# 
# You should have received a copy of the GNU General Public License  
# along with 22_awk. If not, see <http://www.gnu.org/licenses/>.  

BEGIN {
total = 0;
move[0] = "A X";
points[0] = 0+3;
move[1] = "A Y";
points[1] = 3+1;
move[2] = "A Z";
points[2] = 6+2;

move[3] = "B X";
points[3] = 0+1;
move[4] = "B Y";
points[4] = 3+2;
move[5] = "B Z";
points[5] = 6+3;

move[6] = "C X"
points[6] = 0+2;
move[7] = "C Y"
points[7] = 3+3;
move[8] = "C Z";
points[8] = 6+1;

} 
{
  for ( i in points){
    if ($0 == move[i]){
      total += points[i];
    }
  }
} 
END {
 print total;
} 
