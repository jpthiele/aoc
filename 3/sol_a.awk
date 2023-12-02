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
split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",chars, "");
} 
{
  l = length($0)/2;  
  split(substr($0,0,l),comp1,"")
  split(substr($0,l+1,l),comp2,"")
  mat = "0";
  for ( i in comp1){
    for ( j in comp2){
      if ( comp1[i] == comp2[j])
        mat = comp1[i];
    }
  }
  for ( i in chars){
    if ( mat == chars[i]){
      total += i;
    }
  }
} 
END {
  print total;
} 
