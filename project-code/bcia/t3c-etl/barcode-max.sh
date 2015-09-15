#!/bin/bash

. ./config.sh

result=`${SQLCMD}<<EOF
select nvl(max(ID),0) from BARCODE_RECORD WHERE LAST_SCAN_TIME < TO_DATE('$1','yyyy-MM-dd HH24:mi:ss');
EOF`
ret=`echo $result |awk '{print $3}'`

echo BARCODE_RECORD: ID: max = $ret WHEN LAST_SCAN_TIME less than $1

