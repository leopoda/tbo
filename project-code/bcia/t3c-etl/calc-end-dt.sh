#!/bin/bash

. ./config.sh
end_dt=`date "+%Y-%m-%d %H:%M:%S"`

dt_part=`echo $end_dt | awk -F' ' '{printf("%s", $1);}'`
hour_part=`echo $end_dt | awk -F' ' '{printf("%s", $2);}' | awk -F':' '{printf("%s", $1);}'`
min_part=`echo $end_dt | awk -F' ' '{printf("%s", $2);}' | awk -F':' '{printf("%d", $2 / 10);}'`

echo $dt_part $hour_part $min_part | awk '{printf("%s %s:%s:00", $1, $2, $3 * 10);}'
