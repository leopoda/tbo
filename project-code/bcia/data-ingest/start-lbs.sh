#!/bin/bash

export FLUME_HOME=/usr/iop/current/flume-server
#export JAVA_OPTS="-Xms100m -Xmx4096m"

flume-ng agent --conf-file ./lkxxb.conf --name agent4 --conf $FLUME_HOME/conf -Dflume.monitoring.type=http -Dflume.monitoring.port=41412 -Dflume.root.logger=INFO,console
