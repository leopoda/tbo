#!/bin/bash

# export t3cfg=./config.xml
export ORACLE_HOME=/u01/oracle
export db_name=stagedb
export hdfs_path=/bcia/${db_name}
# export tns=APDB

export HADOOP_HOME=/usr/iop/current/hadoop-client
export HIVE_HOME=/usr/iop/current/hive-client
export SQOOP_HOME=/usr/iop/current/sqoop-client

export imp_usr=test_user
export imp_passwd=orcl123
# export uri=jdbc:oracle:thin:@10.39.65.125:1521:ORA10G
export uri=jdbc:oracle:thin:@10.39.65.118:1521:APDB
