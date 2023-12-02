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

function move_of_tail(headcol,headrow,tailcol,tailrow){
  if (headcol-1 > tailcol && headrow-1 >tailrow){
    return tailcol+1 "," tailrow+1;
  }
  if (headcol-1 > tailcol && headrow+1 <tailrow){
    return tailcol+1 "," tailrow-1;
  }
  if (headcol+1 < tailcol && headrow-1 >tailrow){
    return tailcol-1 "," tailrow+1;
  }
  if (headcol+1 < tailcol && headrow+1 <tailrow){
    return tailcol-1 "," tailrow-1;
  }
  
  if (headcol-1 > tailcol){
    return tailcol+1 "," headrow;
  }
  if (headcol+1 < tailcol){
    return tailcol-1 "," headrow;
  }
  if (headrow-1 > tailrow){
    return headcol "," tailrow+1;
  }
  if (headrow+1 < tailrow){
    return headcol "," tailrow-1;
  }
  return tailcol "," tailrow;
}

BEGIN {
ntails = 9;
for ( i = 0; i <= ntails ; i++){
  rows[i] = 1;
  cols[i] = 1;
}
hrow = 1;
hcol = 1;
visited = 1;
tailvis[1 "," 1] = 1;
}
{
  comm = $1;
  move = $2;
  for ( j = 1; j <= move ; j++){
    if (comm == "R"){
      cols[0]++;
    } else if (comm == "U"){
      rows[0]++;
    } else if (comm == "L"){
      cols[0]--;
    } else {
      rows[0]--;
    }
    for ( i = 0 ; i < ntails ; i++){
      split(move_of_tail(cols[i],rows[i],cols[i+1],rows[i+1]),arr,",")
      cols[i+1] = arr[1];
      rows[i+1] = arr[2];
    }
    
    trow = rows[ntails];
    tcol = cols[ntails];
    if (tailvis[trow "," tcol] != 1){
      tailvis[trow "," tcol] = 1;
      visited++;
    }
  }
} 
END {
print visited;
} 
