#!/bin/bash

. ./config.sh
$HADOOP_HOME/bin/hadoop fs -rm -r -skipTrash $hdfs_path/*




