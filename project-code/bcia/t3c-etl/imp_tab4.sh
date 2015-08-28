#!/bin/bash

. ./config.sh

# tab_name=LOG_SEC_AJXXB
tab_name=`${xmlcmd} sel -t -v /config/etl/tables/tab[@id=4]/name ${etlconf}`
tab_field=`${xmlcmd} sel -t -v /config/etl/tables/tab[@id=4]/field ${etlconf}`
lastvalue=`${xmlcmd} sel -t -v /config/etl/tables/tab[@id=4]/value ${etlconf}`

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
                             --check-column ${tab_field} \
                             --last-value "${lastvalue}"

