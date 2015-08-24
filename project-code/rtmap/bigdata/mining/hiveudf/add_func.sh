#!/bin/bash

hiveudf=geom-0.0.1.jar

hadoop fs -rm -skipTrash /user/hive/udfs/$hiveudf
hadoop fs -put ./$hiveudf /user/hive/udfs

# hive -e "use mining;drop function if exists geom;"
hive -e "use mining;create function geom as 'cn.rtmap.bigdata.hiveudf.Geom' using jar 'hdfs:///user/hive/udfs/$hiveudf'"
