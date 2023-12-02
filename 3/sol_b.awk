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
ingroup = 0;
} 
{
  lines[ingroup] = $0;
  if ( ingroup == 2){
    split(lines[0],elf1,"");
    split(lines[1],elf2,"");
    split(lines[2],elf3,"");
    mat = elf1[0];
    for ( i in elf1) {
      for (j in elf2) {
        for ( l in elf3)
        if ( elf1[i] == elf2[j] && elf2[j] == elf3[l] ){
          mat = elf1[i];
        }
      }
    }   
    for ( i in chars ){
      if ( chars[i] == mat){
        total +=i;
      }
    }
    ingroup = 0;
  } else {
    ingroup++;
  }
} 
END {
  print total;
} 
