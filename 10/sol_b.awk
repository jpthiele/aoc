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

function check(cycle,checkcycle,size){
  for(j = 0; j < 6; j++){
    if ( cycle == checkcycle[j]){
      return cycle;
      total += X * cycle;
    }
  }
  return 0;
}
function printcrt(cycle,X){
  if (cycle == X-1 || cycle == X || cycle == X+1){
    printf "#";
  } else {
    printf ".";
  }
}
BEGIN {
cycle = 0;
X = 1;
total = 0;
checksize = 6;
for(j = 0; j < checksize; j++){
  checkcycle[j] = 20+j*40;
}
}
{
  printcrt(cycle % 40,X);
  cycle++;
  if((cycle % 40) ==0){
    print "";
  }
  
  total += X * check(cycle,checkcycle,checksize);
  if ($1 == "addx"){
    printcrt(cycle % 40,X);
    cycle++;
    if((cycle % 40) ==0){
      print "";
    }
    total += X * check(cycle,checkcycle,checksize);
    X+=$2;
  }
} 
END {
  print total;
} 
