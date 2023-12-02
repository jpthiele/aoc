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

function print_array(printarr,width,height){
  for ( k = height ; k > 0; k--){
  for ( i = 1 ; i <= width; i++){
    printf "%s", printarr[i "," k];
  }     
  print "";
  }
}
BEGIN {
  hrow = 1;
  trow = 1;
  hcol = 1;
  tcol = 1;
  visited = 1;
  tailvis[1 "," 1] = 1;
  debug = 0;

  if (debug){
    width = 6;
    height = 5;
    for ( i = 1 ; i <= width; i++){
      for ( k = height ; k > 0; k--){
        printarr[i "," k] = ".";
      }     
    }
  }
}
{
  comm = $1;
  move = $2;
  if (debug){
    print "==", $0, "==";
  }
  for ( j = 1; j <= move ; j++){
    if (comm == "R"){
      hcol++;
      if ( hcol-1 > tcol){
        tcol++;
        trow = hrow;
      }
    } else if (comm == "U"){
      hrow++;
      if (hrow-1 > trow){
        trow++;
        tcol = hcol;
      }
    } else if (comm == "L"){
      hcol--;
      if (hcol+1 < tcol){
        tcol--;
        trow = hrow;
      }
    } else {
      hrow--;
      if (hrow+1 < trow){
        trow--;
        tcol = hcol;
      }
    }
    if (tailvis[trow "," tcol] != 1){
      tailvis[trow "," tcol] = 1;
      visited++;
    }
    if (debug){
      printarr[tcol "," trow] = "T";
      printarr[hcol "," hrow] = "H";
      print_array(printarr,width,height);
      printarr[tcol "," trow] = ".";
      printarr[hcol "," hrow] = ".";
      print "";
    }
  }
} 
END {
print visited;
} 
