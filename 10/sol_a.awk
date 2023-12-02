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
cycle = 0;
X = 1;
total = 0;
for(j = 0; j < 6; j++){
  checkcycle[j] = 20+j*40;
}
}
{
  cycle++;
  for(j = 0; j < 6; j++){
    if ( cycle == checkcycle[j]){
      total += X * cycle;
    }
  }
  if ($1 == "addx"){
    cycle++;
    for(j = 0; j < 6; j++){
      if ( cycle == checkcycle[j]){
        total += X * cycle;
      }
    }
    X+=$2;
  }
} 
END {
  print total;
} 
