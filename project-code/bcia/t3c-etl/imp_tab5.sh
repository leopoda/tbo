#!/bin/bash

# export t3cfg=./config.xml
# export ORACLE_HOME=/u01/oracle
# export db_name=stagedb
# export hdfs_path=/bcia/${db_name}
# # export tns=APDB
# 
# export HADOOP_HOME=/usr/iop/current/hadoop-client
# export HIVE_HOME=/usr/iop/current/hive-client
# export SQOOP_HOME=/usr/iop/current/sqoop-client
# 
# export imp_usr=apdb
# export imp_passwd=apdb
# export uri=jdbc:oracle:thin:@10.39.65.125:1521:ORA10G
. ./config.sh

tab_name=BARCODE_RECORD
target_dir=${hdfs_path}/${tab_name}
hive_tab=${db_name}.${tab_name}

$SQOOP_HOME/bin/sqoop import --hive-import \
                             --connect ${uri} \
                             --username ${imp_usr} \
                             --password ${imp_passwd} \
                             --table ${tab_name} \
                             --target-dir ${target_dir} \
                             --fields-terminated-by '\t' \
                             --null-string '\\N' \
                             --null-non-string '\\N' \
                             --hive-table ${hive_tab} \
                             --num-mappers 1 \
                             --incremental append \
                             --check-column ID \
                             --last-value "31689500"

