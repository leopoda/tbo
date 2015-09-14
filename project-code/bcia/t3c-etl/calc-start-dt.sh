#!/bin/bash

. ./config.sh

tab_name=$1
max_part=`${HIVE_HOME}/bin/hive -S -e "use ${db_name}; show partitions ${tab_name};" | sort -r | head -n 1`

# max_part='lk_date=2014-08-15/lk_hour=08/lk_segmt=3'
part_dt=`echo $max_part | awk -F'/' '{printf("%s=%s=%s", $1,$2,$3);}' | awk -F'=' '{printf("%s %s:%s:00", $2,$4,$6*10);}'`

if [ "$part_dt" != "" ]; then
  echo $part_dt
else
  echo '1900-01-01 00:00:00'
fi
