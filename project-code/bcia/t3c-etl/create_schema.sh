#!/bin/bash

. ./config.sh

$HADOOP_HOME/bin/hadoop fs -mkdir -p $hdfs_path
$HADOOP_HOME/bin/hadoop fs -mkdir -p $hdfs_path/LOG_SEC_LKXXB
$HADOOP_HOME/bin/hadoop fs -mkdir -p $hdfs_path/LOG_SEC_DCSPNCK
$HADOOP_HOME/bin/hadoop fs -mkdir -p $hdfs_path/LOG_SEC_AJXXB
$HADOOP_HOME/bin/hadoop fs -mkdir -p $hdfs_path/BARCODE_RECORD
$HADOOP_HOME/bin/hadoop fs -mkdir -p $hdfs_path/LOG_SEC_SCOSPRSC

$HIVE_HOME/bin/hive -e "create database if not exists stagedb location '$hdfs_path';"
hive -hiveconf hdfs_path=$hdfs_path -hiveconf db_name=$db_name -f ./schema.sql

## verify
hive -e "use $db_name; show tables;"
