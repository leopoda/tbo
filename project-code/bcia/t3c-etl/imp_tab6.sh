#!/bin/bash

. ./config.sh

# tab_name=APDB_PID
tab_name=`${xmlcmd} sel -t -v /config/etl/tables/tab[@id=6]/name ${etlconf}`

target_dir=${hdfs_path}/${tab_name}
# hive_tab=${db_name}.${tab_name}

# move to backup folder
# $HADOOP_HOME/bin/hdfs dfs -mv $hdfs_path/${tab_name}/* $hdfs_path/${tab_name}_BAK

$HADOOP_HOME/bin/hadoop fs -rm -r -skipTrash $hdfs_path/${tab_name}/*
$SQOOP_HOME/bin/sqoop import --connect ${uri} \
                             --username ${imp_usr} \
                             --password ${imp_passwd} \
                             --table ${tab_name} \
                             --target-dir ${target_dir} \
                             --fields-terminated-by '\t' \
                             --null-string '\\N' \
                             --null-non-string '\\N' \
                             --num-mappers 1 

# if [ $? -eq 0 ]; then 
#   $HADOOP_HOME/bin/hdfs dfs -rm -r -skipTrash $hdfs_path/${tab_name}_BAK/*
#   ./bgfs-ren.sh ${tab_name}
# else
#   $HADOOP_HOME/bin/hdfs dfs -mv $hdfs_path/${tab_name}_BAK/* $hdfs_path/${tab_name}
# fi
