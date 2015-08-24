CREATE DATABASE IF NOT EXISTS queue LOCATION '/airport/t3c/queue';
USE queue;

CREATE EXTERNAL TABLE IF NOT EXISTS security_area (
        x DOUBLE,
        y DOUBLE)
COMMENT 'Security are points'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/airport/t3c/queue/security_area';

CREATE EXTERNAL TABLE IF NOT EXISTS brand (
        mac string,
        brand string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/airport/t3c/queue/brand';

CREATE EXTERNAL TABLE IF NOT EXISTS rawdata_position (
        bubble_date STRING,
        mac STRING,
        build_id STRING,
        floor_id STRING,
        axis_x STRING,
        axis_y STRING)
PARTITIONED BY (p_build_id STRING, p_date STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/rawdata/position';

CREATE EXTERNAL TABLE IF NOT EXISTS gat (
       gat_id STRING,
       psg_id STRING,
       flt_id STRING,
       gat_first_scan_tm STRING,
       gat_last_scan_tm STRING,
       gat_scan_no STRING,
       gat_name STRING,
       gat_ship STRING,
       gat_error_code STRING)
PARTITIONED BY (data_date STRING,data_src STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/airport/t3c/queue/gat';

CREATE EXTERNAL TABLE IF NOT EXISTS sck (
       psg_id STRING,
       flt_id STRING,
       sck_sysid STRING,
       sck_inout STRING,
       sck_passflag STRING,
       sck_tm STRING,
       sck_field STRING,
       sck_memo STRING,
       sck_loc STRING,
       sck_handflag STRING,
       sck_pscid STRING,
       sck_oper STRING,
       sck_bag_open STRING,
       sck_out STRING,
       sck_out_no STRING,
       sck_out_tm STRING,
       sck_process_status STRING)
PARTITIONED BY (data_date STRING,data_src STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/airport/t3c/queue/sck';

CREATE EXTERNAL TABLE IF NOT EXISTS sck (
       psg_id STRING,
       flt_id STRING,
       -- sck_sysid STRING,
       -- sck_inout STRING,
       -- sck_passflag STRING,
       sck_tm STRING,
       sck_field STRING)
       -- sck_memo STRING,
       -- sck_loc STRING,
       -- sck_handflag STRING,
       -- sck_pscid STRING,
       -- sck_oper STRING,
       -- sck_bag_open STRING,
       -- sck_out STRING,
       -- sck_out_no STRING,
       -- sck_out_tm STRING,
       -- sck_process_status STRING)
PARTITIONED BY (data_date STRING,data_src STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/airport/t3c/queue/sck';

-- CREATE EXTERNAL TABLE IF NOT EXISTS sck (
--        psg_id STRING,
--        flt_id STRING,
--        sck_sysid STRING,
--        sck_inout STRING,
--        sck_passflag STRING,
--        sck_tm STRING,
--        sck_field STRING,
--        sck_memo STRING,
--        sck_loc STRING,
--        sck_handflag STRING,
--        sck_pscid STRING,
--        sck_oper STRING,
--        sck_bag_open STRING,
--        sck_out STRING,
--        sck_out_no STRING,
--        sck_out_tm STRING,
--        sck_process_status STRING)
-- PARTITIONED BY (data_date STRING,data_src STRING)
-- ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
-- LOCATION '/airport/t3c/queue/sck';

CREATE TABLE IF NOT EXISTS queue_position (
       t BIGINT,
       mac STRING,
       x DOUBLE,
       y DOUBLE)
PARTITIONED BY (dt string,bt int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

CREATE TABLE IF NOT EXISTS dup_psg (
       psg_id STRING,
       cnt INT)
PARTITIONED BY (data_date STRING,data_src STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

CREATE TABLE IF NOT EXISTS pred_sec (
       tm_win INT,
       duration INT)
PARTITIONED BY (data_date STRING,data_src STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

CREATE TABLE IF NOT EXISTS pred_pos_segmt (
       mac STRING,
       t BIGINT,
       src INT)
PARTITIONED BY (dt STRING,bt INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

CREATE TABLE IF NOT EXISTS pred_pos_stats (
       tm_win INT,
       mean BIGINT,
       sd BIGINT,
       cnt BIGINT)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

CREATE TABLE IF NOT EXISTS pred_pos_stay (
       mac STRING,
       duration BIGINT)
PARTITIONED BY (dt STRING,bt INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

