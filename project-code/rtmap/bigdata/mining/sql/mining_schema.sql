
CREATE DATABASE IF NOT EXISTS mining LOCATION '/mining';

USE mining;

CREATE EXTERNAL TABLE IF NOT EXISTS poi_geom (
        poi_name STRING,
        poi_no BIGINT,
        floor STRING,
        x FLOAT,
        y FLOAT,
        geom ARRAY<STRUCT<x : FLOAT, y : FLOAT>>)
PARTITIONED BY (build_id STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
LOCATION '/mining/poi_geom';

CREATE EXTERNAL TABLE IF NOT EXISTS trade (
        store_id STRING, 
        brand_name STRING, 
        paydesk STRING, 
        trade_time STRING, 
        ticket STRING, 
        account STRING, 
        amount FLOAT
)
PARTITIONED BY (build_id STRING, trade_date STRING, trade_type STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/mining/trade';

CREATE EXTERNAL TABLE IF NOT EXISTS rawdata_position (
        bubble_date STRING,
        mac STRING,
        build_id STRING,
        floor_id STRING,
        axis_x STRING,
        axis_y STRING)
PARTITIONED BY (p_build_id STRING, p_date STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS INPUTFORMAT "com.hadoop.mapred.DeprecatedLzoTextInputFormat"
OUTPUTFORMAT "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
LOCATION '/rawdata/position';


CREATE VIEW IF NOT EXISTS vw_poi_geom AS
SELECT poi_name, 
       poi_no, 
       upper(floor) as floor, 
       x, 
       y, 
       geom, 
       build_id
FROM poi_geom;

CREATE VIEW IF NOT EXISTS vw_trade AS
SELECT store_id,
       CASE 
           WHEN substr(store_id, 1, 1) BETWEEN '1' AND '9' THEN upper(concat(substr(store_id, 2, 1), substr(store_id, 1, 1)))
       ELSE 
           upper(substr(store_id, 1, 2))
       END AS floor,
       brand_name, 
       paydesk, 
       substr(trade_time, 1,2) * 3600 + substr(trade_time, 3,2) * 60 as trade_time,
       ticket, 
       account, 
       amount, 
       build_id, 
       trade_date, 
       trade_type
FROM trade;
-- SELECT store_id,
--        CASE 
--            WHEN substr(store_id, 1, 1) BETWEEN '1' AND '9' THEN upper(concat(substr(store_id, 2, 1), substr(store_id, 1, 1)))
--        ELSE 
--            upper(substr(store_id, 1, 2))
--        END AS floor,
--        brand_name, 
--        paydesk, 
--        trade_time, 
--        ticket, 
--        account, 
--        amount, 
--        build_id, 
--        trade_date, 
--        trade_type
-- FROM trade;

CREATE VIEW IF NOT EXISTS vw_rawdata_position AS
SELECT hour(regexp_replace(bubble_date, '/', '-')) * 3600 + 
       minute(regexp_replace(bubble_date, '/', '-')) * 60  +
       second(regexp_replace(bubble_date, '/', '-')) AS time,
       mac,
       -- build_id,
       -- floor_id,
       CASE
           WHEN substr(floor_id, 1, 1) = '1' AND substr(floor_id, 5, 1) = '0' THEN concat('B', regexp_replace(substr(floor_id, 2, 3), '0', ''))
           WHEN substr(floor_id, 1, 1) = '2' AND substr(floor_id, 5, 1) = '0' THEN concat('F', regexp_replace(substr(floor_id, 2, 3), '0', ''))
           WHEN substr(floor_id, 1, 1) = '1' AND substr(floor_id, 5, 1) = '5' THEN concat('B', regexp_replace(substr(floor_id, 2, 3), '0', ''), '-HALF')
           WHEN substr(floor_id, 1, 1) = '2' AND substr(floor_id, 5, 1) = '5' THEN concat('F', regexp_replace(substr(floor_id, 2, 3), '0', ''), '-HALF')
       ELSE
           'UNKNOWN'
       END AS floor,

       axis_x / 1000 AS x,
       -(axis_y / 1000) AS y,
       p_build_id,
       p_date

FROM rawdata_position;
-- FROM default.rawdata_position;

-- SELECT regexp_replace(split(bubble_date, ' ')[1], ':', '') AS time,
--        mac,
--        -- build_id,
--        -- floor_id,
--        CASE
--            WHEN substr(floor_id, 1, 1) = '1' AND substr(floor_id, 5, 1) = '0' THEN concat('B', regexp_replace(substr(floor_id, 2, 3), '0', ''))
--            WHEN substr(floor_id, 1, 1) = '2' AND substr(floor_id, 5, 1) = '0' THEN concat('F', regexp_replace(substr(floor_id, 2, 3), '0', ''))
--            WHEN substr(floor_id, 1, 1) = '1' AND substr(floor_id, 5, 1) = '5' THEN concat('B', regexp_replace(substr(floor_id, 2, 3), '0', ''), '-HALF')
--            WHEN substr(floor_id, 1, 1) = '2' AND substr(floor_id, 5, 1) = '5' THEN concat('F', regexp_replace(substr(floor_id, 2, 3), '0', ''), '-HALF')
--        ELSE
--            'UNKNOWN'
--        END AS floor,
-- 
--        axis_x / 1000 AS x,
--        -(axis_y / 1000) AS y,
--        p_build_id,
--        p_date
-- FROM default.rawdata_position;


