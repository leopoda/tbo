CREATE DATABASE IF NOT EXISTS ${hiveconf:db_name} LOCATION '${hiveconf:hdfs_path}';
USE ${hiveconf:db_name};

CREATE TABLE IF NOT EXISTS gat (
       lk_id          string,
       last_scan_time string)
PARTITIONED BY (scan_date string, scan_hour smallint, scan_minute smallint)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '${hiveconf:hdfs_path}/gat';

