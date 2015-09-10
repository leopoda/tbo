#!/bin/bash

export db_name=queue
export bgfs_path=${BGFS_PREFIX}/bcia/${db_name}

$HIVE_HOME/bin/hive -e "create database if not exists ${db_name} location '$hdfs_path';"
$HIVE_HOME/bin/hive -hiveconf hdfs_path=$hdfs_path -hiveconf db_name=$db_name -f ./${db_name}-schema.sql