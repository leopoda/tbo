#!/bin/bash

JOB_DIR=/bcia/ingest
JOB_LOG=`date +%Y%m%d%H`.log

ps_out=`ps -ef | grep $1 | grep -v 'grep' | grep -v $0` 
result=$(echo $ps_out | grep "$1")

if [[ "$result" != "" ]];then
    echo `date '+%Y-%m-%d %H:%M:%S'` warn: ingestion job is already running, skipped the running this time. >> ${JOB_DIR}/log/${JOB_LOG} 2>&1
else
    echo `date '+%Y-%m-%d %H:%M:%S'` info: launched job $1 >> ${JOB_DIR}/log/${JOB_LOG} 2>&1
    nohup $1 >> ${JOB_DIR}/log/${JOB_LOG} 2>&1 &
fi
