-- for dynamic partition
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=2000;
set hive.exec.max.dynamic.partitions=10000;

-- switch db
use queue;

-- temp table for duplicated passengers
alter table dup_psg drop if exists partition (data_date='${hiveconf:dt}');

insert overwrite table dup_psg partition(data_date,data_src)
select psg_id,
       count(*) cnt,
       data_date,
       data_src
from (
    select g.psg_id,
           g.data_date,
           g.data_src
    from gat g
    join sck s
      on g.psg_id = s.psg_id and g.flt_id = s.flt_id and g.data_date = s.data_date and g.data_src = s.data_src
    where g.data_date = '${hiveconf:dt}' and g.data_src = 'E'
) x
group by psg_id, data_date, data_src
having count(*) > 1;


alter table pred_sec drop if exists partition (data_date='${hiveconf:dt}');

insert overwrite table pred_sec partition(data_date,data_src)
select check_window as tm_win,
       round(avg(duration)) as duration,
       '${hiveconf:dt}',
       'E'
from (
    select *
    from (
        select round(t2 / 60 / 10) as check_window,
               t2 - t1 as duration
        from (
            select g.psg_id,
                   g.flt_id,
                   substr(g.gat_last_scan_tm, 9, 2) * 3600 + substr(g.gat_last_scan_tm, 11, 2) * 60 + substr(g.gat_last_scan_tm, 13, 2) as t1,
                   substr(s.sck_tm, 9, 2) * 3600 + substr(s.sck_tm, 11, 2) * 60 + substr(s.sck_tm, 13, 2) as t2,
                   s.sck_field
            from gat g
            left join sck s
              on g.psg_id = s.psg_id
            left join dup_psg d
              on g.psg_id = d.psg_id
            where g.data_date = '${hiveconf:dt}' and g.data_src = 'E' and d.cnt is null
        ) x
    ) xx
    where duration > 0
) xxx
group by check_window
order by check_window;
