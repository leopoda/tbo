-- for dynamic partition
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=2000;
set hive.exec.max.dynamic.partitions=10000;

-- switch db
use queue;

-- purge data by date
alter table queue_position drop if exists partition (dt='${hiveconf:dt}');

-- load data
insert overwrite table queue_position partition(dt,bt)
select hour * 3600 + min * 60 + sec as t,
       t1.mac, 
       x, 
       y,
       '${hiveconf:dt}' as dt,
       cast(round((hour * 3600 + min * 60 + sec) / 60 / 10) as int) as bt 
from (
    select substr(bubble_date, 12, 2) as hour,
           substr(bubble_date, 15, 2) as min,
           substr(bubble_date, 18, 2) as sec,
           mac,
           axis_x / 1000 as x,
           axis_y / -1000 as y
    from rawdata_position p
    where p_build_id = '860100010030100003' and p_date = '${hiveconf:dt}' and inpoly(axis_x, axis_y) = 'Y'
) t1
where substr(t1.mac, 0, 6) in (select distinct mac from brand);


alter table pred_pos_segmt drop if exists partition (dt='${hiveconf:dt}');

insert overwrite table pred_pos_segmt partition(dt,bt)
select x.mac, p3.t, p3.bt as src, x.dt, x.bt
from (
    select p1.dt,
           p1.mac,
           p1.bt
    from queue_position p1
    left join queue_position p2
      on p1.bt + 1 = p2.bt and p1.mac = p2.mac
    where p1.dt = '${hiveconf:dt}' and p2.mac is null
) x
join queue_position p3
  on x.mac = p3.mac and x.dt = p3.dt
where p3.bt <= x.bt
distribute by x.bt
sort by x.bt asc, src asc, p3.t asc;


alter table pred_pos_stay drop if exists partition (dt='${hiveconf:dt}');

insert overwrite table pred_pos_stay partition(dt,bt)
select mac,
       max(t) - min(t) as duration,
       dt,
       bt
from pred_pos_segmt
group by dt, bt, mac
having (max(t) - min(t) > 0) and (max(t) - min(t) < 2 * 60 * 60) and dt = '${hiveconf:dt}';


alter table pred_pos_stats drop if exists partition (dt='${hiveconf:dt}');

insert overwrite table pred_pos_stats partition(dt)
select bt,
       round(avg(duration)) as mean,
       round(stddev(duration)) as sd,
       count(mac) as cnt,
       dt
from pred_pos_stay
group by dt, bt
having dt = '${hiveconf:dt}';

