USE ${hiveconf:db_name};

CREATE TABLE IF NOT EXISTS gat (
       lk_id          string,
       last_scan_time string)
PARTITIONED BY (lk_date string, lk_hour smallint, lk_segmt smallint)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
-- LOCATION '${hiveconf:hdfs_path}/gat';
