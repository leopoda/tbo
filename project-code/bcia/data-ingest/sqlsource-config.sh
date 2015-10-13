#!/bin/bash

export FLUME_HOME=/usr/iop/current/flume-server
export status_file_path=/var/lib/flume
export ojdbc_path=../../../../tools/oracle/orc-jdbc
export sql_source_jar=target/flume-ng-sql-source-1.3-SNAPSHOT.jar
export plugin_dir=${FLUME_HOME}/plugins.d

rm -rf ${status_file_path}/*
rm -rf ${plugin_dir}/sql-source/lib/*
rm -rf ${plugin_dir}/sql-source/libext/*

mkdir -p ${plugin_dir}/sql-source/lib 
mkdir -p ${plugin_dir}/sql-source/libext

cp -v ${ojdbc_path}/ojdbc7.jar ${plugin_dir}/sql-source/libext
cp -v ${sql_source_jar} ${plugin_dir}/sql-source/lib

# for debug
tree ${plugin_dir}
