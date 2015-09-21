#!/bin/bash

export FLUME_HOME=/usr/hdp/current/flume-server

rm -rf $FLUME_HOME/plugins.d/sql-source/lib/*
cp -v target/flume-ng-sql-source-1.3-SNAPSHOT.jar $FLUME_HOME/plugins.d/sql-source/lib

flume-ng agent --conf-file ./sql-source.conf --name agent2 --conf $FLUME_HOME/conf -Dflume.root.logger=INFO,console
