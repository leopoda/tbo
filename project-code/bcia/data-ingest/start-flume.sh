#!/bin/bash

export FLUME_HOME=/usr/iop/current/flume-server

rm -rf /var/lib/flume/*
rm -rf $FLUME_HOME/plugins.d/sql-source/lib/*
rm -rf $FLUME_HOME/plugins.d/sql-source/libext/*

mkdir -p $FLUME_HOME/plugins.d/sql-source/lib 
mkdir -p $FLUME_HOME/plugins.d/sql-source/libext
# mkdir -p $FLUME_HOME/plugins.d/lib/sql-source/libext

cp -v ../../../../tools/oracle/orc-jdbc/ojdbc7.jar $FLUME_HOME/plugins.d/sql-source/libext
cp -v target/flume-ng-sql-source-1.3-SNAPSHOT.jar $FLUME_HOME/plugins.d/sql-source/lib

flume-ng agent --conf-file ./agent1.conf --name agent1 --conf $FLUME_HOME/conf -Dflume.root.logger=INFO,console
