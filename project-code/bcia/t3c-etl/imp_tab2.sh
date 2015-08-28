#!/bin/bash

. ./config.sh

tab_name=`${xmlcmd} sel -t -v /config/etl/tables/tab[@id=2]/name ${etlconf}`
tab_field=`${xmlcmd} sel -t -v /config/etl/tables/tab[@id=2]/field ${etlconf}`
lastvalue=`${xmlcmd} sel -t -v /config/etl/tables/tab[@id=2]/value ${etlconf}`

target_dir=${hdfs_path}/${tab_name}
hive_tab=${db_name}.${tab_name}

$SQOOP_HOME/bin/sqoop import --hive-import \
                             --connect ${uri} \
                             --username ${imp_usr} \
                             --password ${imp_passwd} \
                             --query 'select sc_ffid, sc_brdno, operation_date, flight_no, sc_seat, sc_dept, sc_inout, sc_passflag, sc_sctm, sc_field, sc_sccm, sc_scloc, sc_handflag, sc_ctype, sc_cnumber, sc_cvalidate, sc_cdep, sc_address, sc_birthdar, sc_nation, sc_chnname, sc_name, sc_gender, sc_pscid, flgt_id, mb_id, process_status, last_update_date from log_sec_scosprsc where $CONDITIONS' \
                             --target-dir ${target_dir} \
                             --fields-terminated-by '\t' \
                             --null-string '\\N' \
                             --null-non-string '\\N' \
                             --hive-table ${hive_tab} \
                             --num-mappers 1 \
                             --incremental append \
                             --check-column ${tab_field} \
                             --last-value ${lastvalue}

if [ $? -eq 0 ]; then
  result=`${SQLCMD}<<EOF
select nvl(max($tab_field),0) from ${tab_name};
EOF`

  if [ $? -eq 0 ]; then
    ret=`echo $result |awk '{print $3}'`
    if [ "${ret}" != "${lastvalue}" ]; then 
      ./track-last.sh 2 ${ret}
    fi
  fi
fi 