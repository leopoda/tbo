#!/bin/bash

. ./config.sh

# tab_name=LOG_SEC_AJXXB
tab_name=`${xmlcmd} sel -t -v /config/etl/tables/tab[@id=4]/name ${etlconf}`
tab_field=`${xmlcmd} sel -t -v /config/etl/tables/tab[@id=4]/field ${etlconf}`
lastvalue=`${xmlcmd} sel -t -v /config/etl/tables/tab[@id=4]/value ${etlconf}`

target_dir=${hdfs_path}/${tab_name}
hive_tab=${db_name}.${tab_name}

echo info: incremental import data to hadoop from ${tns}.${imp_usr}.${tab_name}...
result=`${SQLCMD}<<EOF
select nvl(to_char(max($tab_field), 'yyyy-MM-dd HH24:mi:ss'), '1900-01-01 00:00:00') as curr_max from ${tab_name};
EOF`

if [ $? -eq 0 ]; then
  ret=`echo $result | awk '{printf("%s %s", $3,$4);}'`
  if [ "${ret}" != "${lastvalue}" ]; then 
    $SQOOP_HOME/bin/sqoop import --connect ${uri} \
                                 --username ${imp_usr} \
                                 --password ${imp_passwd} \
                                 --table ${tab_name} \
                                 --target-dir ${target_dir} \
                                 --fields-terminated-by '\t' \
                                 --null-string '\\N' \
                                 --null-non-string '\\N' \
                                 --num-mappers 1 \
                                 --incremental append \
                                 --check-column ${tab_field} \
                                 --last-value "${lastvalue}"
    if [ $? -eq 0 ]; then
      ${xmlcmd} ed --inplace -u /config/etl/tables/tab[@id=4]/value -v "$ret" ${etlconf}
      ./bgfs-ren.sh ${tab_name}
    fi
  fi

  ## for debug
  echo info: sql result: ${result}
  echo info: curr value: ${ret}
  echo info: last value: ${lastvalue}
fi 