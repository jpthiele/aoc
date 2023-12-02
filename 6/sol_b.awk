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
#packet_size = 4; # part one
packet_size = 14; # part two
} 
{
  split($0,arr,"")
  start_of_marker = 0;
  for ( i = packet_size ; i < length($0);i++ ){
    found = 1;
    for (j = 0 ; j < packet_size-1 ; j++){
      for (h = j+1 ; h < packet_size; h++){
        if (arr[i-j] == arr[i-h]){
          found = 0;
        }
      }
    }
    if ( found == 1){
      start_of_marker = i;
      break;
    }
  }
  print start_of_marker
} 
END {
} 
