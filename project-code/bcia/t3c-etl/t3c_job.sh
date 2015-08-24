#!/bin/bash

T3C_JOB_DIR=/root/airport/t3c_etl
T3C_JOB_LOG=`date +%Y-%m-%d`.log

ps_out=`ps -ef | grep $1 | grep -v 'grep' | grep -v $0`
result=$(echo $ps_out | grep "$1")

if [[ "$result" != "" ]];then
    echo "Running, skipped"
else
    echo launch job...
    nohup ${T3C_JOB_DIR}/$1 > ${T3C_JOB_DIR}/log/${T3C_JOB_LOG} 2>&1 &
fi


