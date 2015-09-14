#!/bin/bash

. ./config.sh

# end_dt='2014-08-15 08:20:00'
# 
# last_ten_min_dt=$(( `date -d "${end_dt}" '+%s'` - ( 10 * 60 ) ))
# start_dt=`date -d "@$last_ten_min_dt" '+%Y-%m-%d %H:%M:%S'`

echo info: start_dt=$start_dt end_dt=$end_dt

query="insert overwrite table sck partition(lk_date, lk_hour, lk_segmt) 
select lk_id,
       safe_time,
       to_date(safe_time) lk_date,
       lpad(hour(safe_time), 2, '0') lk_hour,
       case
           when minute(safe_time)>=0  and minute(safe_time) <= 9  then 1
           when minute(safe_time)>=10 and minute(safe_time) <= 19 then 2
           when minute(safe_time)>=20 and minute(safe_time) <= 29 then 3
           when minute(safe_time)>=30 and minute(safe_time) <= 39 then 4
           when minute(safe_time)>=40 and minute(safe_time) <= 49 then 5
           when minute(safe_time)>=50 and minute(safe_time) <= 59 then 6
       end lk_segmt
from vw_log_sec_ajxxb
where (safe_time > '${start_dt}' and safe_time <= '${end_dt}') and 
      safe_time is not null;
"

$HIVE_HOME/bin/hive -S -e "$hivecfg$query"
