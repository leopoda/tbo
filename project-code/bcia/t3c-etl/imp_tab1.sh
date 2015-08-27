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

tab_name=LOG_SEC_DCSPNCK
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
                             --check-column MB_ID \
                             --last-value 72293500

# --query 'select ck_ffid, ck_brdno, operation_date, flight_no, ck_loc, ck_dept, ck_prsta, ck_dest, ck_name, ck_chnname, ck_gender, ck_ics, ck_vip, ck_seat, ck_class, ck_inf, ck_gates, ck_ctct, ck_cert, ck_etfl, ck_etno, ck_fffr, ck_group, ck_bags, ck_bagwgt, ck_depttm, ck_sip, ck_ckipid, ck_ckiagt, ck_ckitm, ck_ckiofc, ck_tsflag, flgt_id, mb_id, process_status, last_update_date from log_sec_dcspnck where $CONDITIONS' \