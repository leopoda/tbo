#!/bin/bash

export xmlcmd=/usr/bin/xml
export etlconf=./config.xml

export ORACLE_HOME=/u01/oracle
export HADOOP_HOME=/usr/iop/current/hadoop-client
export HIVE_HOME=/usr/iop/current/hive-client
export SQOOP_HOME=/usr/iop/current/sqoop-client

# export imp_usr=apdb
# export imp_passwd=apdb
# export uri=jdbc:oracle:thin:@10.39.65.125:1521:ORA10G

## parse config values from xml config file
export imp_usr=`${xmlcmd} sel -t -v /config/etl/user ${etlconf}`
export imp_passwd=`${xmlcmd} sel -t -v /config/etl/password ${etlconf}`
export uri=`${xmlcmd} sel -t -v /config/etl/jdbc-url ${etlconf}`

export db_name=`${xmlcmd} sel -t -v /config/etl/dest-db ${etlconf}`
export hdfs_path=/bcia/${db_name}

export tns=`echo ${uri} | awk -F':' '{print $6;}'`
export SQLCMD="$ORACLE_HOME/bin/sqlplus -s ${imp_usr}/${imp_passwd}@${tns}"
