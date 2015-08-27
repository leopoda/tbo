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

tab_name=LOG_SEC_LKXXB
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
                             --check-column LAST_UPDATE_DATE \
                             --last-value "2014-08-20 6:39:15"

## --query 'select sysid, lk_id ,lk_flight ,lk_date ,lk_seat ,lk_strt ,lk_dest ,lk_bdno ,lk_ename ,lk_cname ,lk_card ,lk_cardid ,lk_nation ,lk_sex ,lk_tel ,lk_resr ,lk_inf ,lk_infname ,lk_class ,lk_chkn ,lk_chkt ,lk_gateno ,lk_vip ,lk_insur ,lk_outtime ,lk_del ,ajxxb_id ,safe_time ,flgt_id ,file_name ,process_status ,last_update_date from log_sec_lkxxb where $CONDITIONS' \
