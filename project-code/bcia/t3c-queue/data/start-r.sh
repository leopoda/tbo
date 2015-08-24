#!/bin/bash

export HIVE_HOME=/usr/hdp/current/hive-client
export HADOOP_HOME=/usr/hdp/current/hadoop-client


rm -rf ./*.png

if [ $# -eq 0 ]; then
    R --no-save
else
    /usr/bin/Rscript $@ 
fi
