#!/bin/bash

. ./sqlsource-config.sh
flume-ng agent --conf-file ./lkxxb.conf --name agent2 --conf $FLUME_HOME/conf -Dflume.root.logger=INFO,console
