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
FS = "";
shufflemode = 0;
numstacks = 0;
} 
{
  if ($0 == ""){
    shufflemode = 1;
    for ( j = 0 ; j < numstacks ; j++ ){
      stackheight[j] = 0;
    }
    for ( i = length(boxlines) ; i > 0 ; i--){
     ind = length(boxlines)-i+1;
     split(boxlines[i],str1,"");
     for ( j = 0 ; j < numstacks ; j++ ){
      jind = 4*j+2;
      if ( str1[jind] != " "){
        print str1[jind],jind
        boxes[ind "," j] = str1[jind];
        stackheight[j]++;
      }
     }
    }
    FS = " "
  } else if (shufflemode == 0){
    if ( $2 != "1"){
      boxlines[NR] = $0
    } else {
      for ( i = 2 ; i < length($0) ; i+= 4){
        numstacks = $i;
      }
    }
  } else {
    numtomove = $2;
    src = $4-1;
    dst = $6-1;
    for ( k = 0 ; k < numtomove ; k ++ ){
      stackheight[dst]++;
      inddst = stackheight[dst];
      indsrc = stackheight[src];
      boxes[inddst "," dst] = boxes[indsrc "," src];
      boxes[indsrc "," src] = "";
      stackheight[src]--;
    }
  
  }
} 
END {
str = ""
for ( j = 0 ; j < numstacks ;j++){
  str = sprintf("%s%s",str,boxes[stackheight[j] "," j]);
}
print str;
} 
