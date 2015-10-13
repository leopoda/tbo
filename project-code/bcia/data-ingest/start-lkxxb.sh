#!/bin/bash

# export FLUME_HOME=/usr/iop/current/flume-server
# 
# rm -rf /var/lib/flume/*
# rm -rf $FLUME_HOME/plugins.d/sql-source/lib/*
# rm -rf $FLUME_HOME/plugins.d/sql-source/libext/*
# 
# mkdir -p $FLUME_HOME/plugins.d/sql-source/lib 
# mkdir -p $FLUME_HOME/plugins.d/sql-source/libext
# # mkdir -p $FLUME_HOME/plugins.d/lib/sql-source/libext
# 
# cp -v ../../../../tools/oracle/orc-jdbc/ojdbc7.jar $FLUME_HOME/plugins.d/sql-source/libext
# cp -v target/flume-ng-sql-source-1.3-SNAPSHOT.jar $FLUME_HOME/plugins.d/sql-source/lib

. ./sqlsource-config.sh
flume-ng agent --conf-file ./lkxxb.conf --name agent3 --conf $FLUME_HOME/conf -Dflume.root.logger=INFO,console
