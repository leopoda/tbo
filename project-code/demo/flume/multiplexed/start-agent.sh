#!/bin/bash

rm -rf ~/.flume/*

export FLUME_HOME=/usr/hdp/current/flume-server
flume-ng agent --conf-file ./multiplex.properties --name agent1 --conf $FLUME_HOME/conf -Dflume.root.logger=INFO,console