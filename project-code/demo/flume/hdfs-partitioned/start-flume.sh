#!/bin/bash

rm -rf ~/.flume/file-channel/checkpoint/*
rm -rf ~/.flume/file-channel/data/*
 
export FLUME_HOME=/usr/hdp/current/flume-server
flume-ng agent --conf-file ./spool-to-hdfs.properties --name agent1 --conf $FLUME_HOME/conf -Dflume.root.logger=INFO,console

