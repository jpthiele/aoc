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
FS = ",";
} 
{
  split($1,a1,"-")
  split($2,a2,"-")
  if ( a1[1] >= a2[1] && a1[1] <= a2[2] ){
    total++;
  } else if ( a1[2] >= a2[1] && a1[2] <= a2[2] ){
    total++
  } else if ( a2[1] >= a1[1] && a2[1] <= a1[2] ){
    total++
  } else if ( a2[2] >= a1[1] && a2[2] <= a1[2] ){
    total++
  }
} 
END {
  print total;
} 
