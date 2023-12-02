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
rows = 1;
cols = 1;
}
{
if (NR == 1){
  cols += length($0);
}
split($0,arr,"");
for ( i = 1 ; i < cols ; i++ ){
  trees[rows "," i] = arr[i];
}
rows++;
} 
END {
visible = 2 * (rows-1) + 2 * (cols-3);
for ( i = 2 ; i < rows-1 ; i++ ){
  for ( j = 2 ; j < cols-1 ; j++ ){
    left = 0; 
    right = 0;
    up = 0; 
    down = 0;
    tree = trees[i "," j];
    for ( k = 1 ; k < i ; k++ ){
      if (trees[k "," j] >= tree){
        left = 1;
      }
    }
    for ( k = i+1 ; k < cols ; k++ ){
      if (trees[k "," j] >= tree){
        right = 1;
      }
    }
    for ( k = 1 ; k < j ; k++ ){
      if (trees[i "," k] >= tree){
        up = 1;
      }
    }
    for ( k = j+1 ; k < rows ; k++ ){
      if (trees[i "," k] >= tree){
        down = 1;
      }
    }
    if( up == 0 || down == 0 || left == 0 || right == 0){
      visible++;
    }
  }
}
print visible
} 
