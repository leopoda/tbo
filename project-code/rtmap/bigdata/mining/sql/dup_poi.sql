USE mining;

CREATE TABLE IF NOT EXISTS dup_poi (
        poi_name STRING,
        floor STRING)
PARTITIONED BY (build_id STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/mining/dup_poi';

-- for joycity
ALTER TABLE dup_poi ADD IF NOT EXISTS PARTITION(build_id='860100010020300001') LOCATION '/mining/dup_poi/860100010020300001';

