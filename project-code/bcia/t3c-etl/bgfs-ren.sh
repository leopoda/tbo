#!/bin/bash

# tab_name=LOG_SEC_SCOSPRSC
# bgfs_path=/mnt/bigfs/bcia/stagedb

tab_name=$1
for f in `ls -t -r ${bgfs_path}/${tab_name}/part-m*` 
do
  prefix=${tab_name,,}
  suffix=`date +%Y%m%d%H%M%S`

  ## compose file name with lower letters
  target_name=${prefix}-${suffix}.txt
  
  ## rename file
  mv $f ${bgfs_path}/${tab_name}/${target_name}
  sleep 1
done 

## for debug
ls -l -t -r ${bgfs_path}/${tab_name}