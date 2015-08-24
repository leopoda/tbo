#!/bin/bash

t3cfg=./config.xml
ORACLE_HOME=/usr/lib/oracle/11.2/client64
hdfs_path=/airport/t3c/apdb_staged

HADOOP_HOME=/usr/hdp/current/hadoop-client
HIVE_HOME=/usr/hdp/current/hive-client
SQOOP_HOME=/usr/hdp/current/sqoop-client


function hdfs_init() {
  $HADOOP_HOME/bin/hadoop fs -mkdir -p $hdfs_path
  $HIVE_HOME/bin/hive -e "create database if not exists apdb_staged location '$hdfs_path';"
}

function hive_import() {
  jdbc=`xml sel -t -v /config/etl/jdbc-url $t3cfg`
  user=`xml sel -t -v /config/etl/user $t3cfg`
  pwd=`xml sel -t -v /config/etl/password $t3cfg`
  dest=`xml sel -t -v /config/etl/dest-db $t3cfg`


  #echo jdbc: $jdbc
  #echo user: $user
  #echo pwd: $pwd
  #echo dest: $dest
  
  for tab_id in `xml sel -T -t -m /config/etl/tables/tab -s A:N:- "@id" -v @id -n $t3cfg`
  do
    tab_name=`xml sel -t -v /config/etl/tables/tab[@id=$tab_id]/name $t3cfg`
    tab_field=`xml sel -t -v /config/etl/tables/tab[@id=$tab_id]/field $t3cfg`
    tab_mod=`xml sel -t -v /config/etl/tables/tab[@id=$tab_id]/mode $t3cfg`

    if [ "$tab_mod" != "lastmodified" ]; then
      tab_val=`xml sel -t -v /config/etl/tables/tab[@id=$tab_id]/value $t3cfg`
    else
      tab_val=`xml sel -t -v /config/etl/tables/tab[@id=$tab_id]/value $t3cfg | awk -F"\t" '{printf("%s",$1);}'`
    fi


    echo debug: $tab_id $tab_name $tab_field $tab_mod $tab_val
    $SQOOP_HOME/bin/sqoop import --hive-import \
                                 --connect $jdbc \
                                 --username $user \
                                 --password $pwd \
                                 --table $tab_name \
                                 --hive-table $dest.$tab_name \
                                 --fields-terminated-by '\t' \
                                 --null-string '\\N' \
                                 --null-non-string '\\N' \
                                 --num-mappers 1 \
                                 --incremental $tab_mod \
                                 --check-column $tab_field \
                                 --last-value "$tab_val"


    SQLPLUS_CMD="$ORACLE_HOME/bin/sqlplus -s $user/$pwd@APDB2"
    if [ "$tab_mod" != "lastmodified" ]; then
      result=`${SQLPLUS_CMD}<<EOF
select nvl(max($tab_field),0) from ${tab_name};
EOF`

      # echo $result
      t1=`echo $result |awk '{print $3}'`
      xml ed --inplace -u /config/etl/tables/tab[@id=$tab_id]/value -v $t1 $t3cfg
    else
      result=`${SQLPLUS_CMD}<<EOF
select nvl(to_char(max($tab_field), 'yyyy-MM-dd HH24:mi:ss'), '1900-01-01 00:00:00') as curr_max from ${tab_name};
EOF`

      # echo $result
      t2=`echo $result | awk '{printf("%s %s", $3,$4);}'`
      xml ed --inplace -u /config/etl/tables/tab[@id=$tab_id]/value -v "$t2" $t3cfg
    fi
  done
}


hdfs_init
hive_import


#if [ $# -eq 0 ]; then
#  while true
#  do
#    hive_import
#    sleep 120
#  done
#  exit
# fi
