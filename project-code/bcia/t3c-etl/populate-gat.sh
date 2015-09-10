#!/bin/bash

. ./config.sh

hivecfg="
use stagedb;
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=2000;
set hive.exec.max.dynamic.partitions=10000;
"

query="insert overwrite table gat partition(lk_date, lk_hour, lk_segmt) 
select b.lk_id, 
       -- b.lk_flight, 
       -- b.last_update_date, 
       -- a.passager_name, 
       -- a.flight, 
       -- a.boarding_no, 
       a.last_scan_time,
       to_date(a.last_scan_time) lk_date,
       hour(a.last_scan_time) lk_hour,
       CASE
           WHEN minute(a.last_scan_time)>=0 and minute(a.last_scan_time) <= 10 THEN 1
           WHEN minute(a.last_scan_time)>10 and minute(a.last_scan_time) <= 20 THEN 2
           WHEN minute(a.last_scan_time)>20 and minute(a.last_scan_time) <= 30 THEN 3
           WHEN minute(a.last_scan_time)>30 and minute(a.last_scan_time) <= 40 THEN 4
           WHEN minute(a.last_scan_time)>40 and minute(a.last_scan_time) <= 50 THEN 5
           WHEN minute(a.last_scan_time)>50 and minute(a.last_scan_time) <= 59 THEN 6
       END lk_segmt
       -- ,c.cki_type
from vw_barcode_record a
left join vw_log_sec_lkxxb b
  on a.flight = b.lk_flight and a.boarding_no = b.lk_bdno 
left join vw_apdb_pid c
  on b.lk_chkn = cki_pid
where (a.last_scan_time between '2014-08-17 06:00:00' and '2014-08-17 06:10:00') and
      a.last_scan_time is not null and 
      b.lk_id is not null;
"

$HIVE_HOME/bin/hive -S -hiveconf db_name=$db_name -e "$hivecfg$query" 

