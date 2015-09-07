#!/bin/bash

JOB_DIR=/bcia/ingest
JOB_LOG=`date +%Y-%m-%d`.log

ps_out=`ps -ef | grep $1 | grep -v 'grep' | grep -v $0`
result=$(echo $ps_out | grep "$1")

if [[ "$result" != "" ]];then
    echo "Running, skipped" >> ${JOB_DIR}/log/${JOB_LOG} 2>&1 
else
    echo launch job...
    nohup $1 >> ${JOB_DIR}/log/${JOB_LOG} 2>&1 &
fi


