#!/bin/bash
. ./config.sh

export db_name=queue
export hdfs_path=/bcia/${db_name}

$HADOOP_HOME/bin/hadoop fs -mkdir -p $hdfs_path
$HADOOP_HOME/bin/hadoop fs -mkdir -p $hdfs_path/gat

$HIVE_HOME/bin/hive -e "create database if not exists ${db_name} location '$hdfs_path';"
$HIVE_HOME/bin/hive -hiveconf hdfs_path=$hdfs_path -hiveconf db_name=$db_name -f ./${db_name}-schema.sql
