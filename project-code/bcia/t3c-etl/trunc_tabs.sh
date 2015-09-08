#!/bin/bash

. ./config.sh
$HADOOP_HOME/bin/hadoop fs -rm -r -skipTrash $hdfs_path/LOG_SEC_DCSPNCK/*
$HADOOP_HOME/bin/hadoop fs -rm -r -skipTrash $hdfs_path/LOG_SEC_SCOSPRSC/*
$HADOOP_HOME/bin/hadoop fs -rm -r -skipTrash $hdfs_path/LOG_SEC_LKXXB/*
$HADOOP_HOME/bin/hadoop fs -rm -r -skipTrash $hdfs_path/LOG_SEC_AJXXB/*
$HADOOP_HOME/bin/hadoop fs -rm -r -skipTrash $hdfs_path/BARCODE_RECORD/*
$HADOOP_HOME/bin/hadoop fs -rm -r -skipTrash $hdfs_path/APDB_PID/*
$HADOOP_HOME/bin/hadoop fs -rm -r -skipTrash $hdfs_path/APDB_PID_BAK/*
