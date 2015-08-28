#!/bin/bash

. ./config.sh
${xmlcmd} ed --inplace -u /config/etl/tables/tab[@id=$1]/value -v $2 ${etlconf}
