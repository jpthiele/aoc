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
currentdir = " "
numsubdirs[" "] = 0; 
numfiles[" "] = 0;
dirsize[" "] = 0;
maxsize = 100000
totalspace = 70000000;
wantedspace = 30000000;
}
{
## ignore first line
if(NR > 1){
  if ($1 == "\$") {#this is a command
    if($2 == "cd") {#change directory
      if($3 == ".."){
        currentdir = parentdir[currentdir];
      } else {
        currentdir = sprintf("%s/%s",currentdir,$3);
        dirsize[currentdir] = 0;
        numsubdirs[currentdir] = 0;
      }
    }
  }
  else {
    if($1 == "dir") {#this is a subdirectory
      numsubdirs[currentdir]++;
      tmpdir = sprintf("%s/%s",currentdir,$2);
      subdir[currentdir "," numsubdirs[currentdir]] = tmpdir;
#       print tmpdir;
      parentdir[tmpdir] = currentdir;
    } else {
      dirsize[currentdir]+=$1;
    }
  }
}
} 
END {
  #going through all subdirs again...
  currentdir = " "
  iterating = 1;
  subdirindex[" "] = 1;
  totalsize = 0;
  while (iterating == 1){
    if (subdirindex[currentdir] > numsubdirs[currentdir]){ #all subdirs visited
      if (currentdir == " ") {
        iterating = 0;
      } else {
        dirsize[parentdir[currentdir]]+=dirsize[currentdir];
        currentdir = parentdir[currentdir];
        subdirindex[currentdir]++;
      }
    } else {
      tmpdir = subdir[currentdir "," subdirindex[currentdir]];
      currentdir = tmpdir;
      subdirindex[currentdir] = 1;
    }
  }
  freespace = totalspace- dirsize[" "];
  spacetorm = wantedspace- freespace;
  mindir = " ";
  for (i in dirsize){
    if (dirsize[i] > spacetorm ){
      if (dirsize[i] < dirsize[mindir]){
        mindir = i;
      }
    }
  }
  print mindir, dirsize[mindir]
} 
