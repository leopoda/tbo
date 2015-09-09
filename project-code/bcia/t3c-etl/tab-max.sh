#!/bin/bash

. ./config.sh

result=`${SQLCMD}<<EOF
select nvl(max(MB_ID),0) from LOG_SEC_DCSPNCK;
EOF`

ret=`echo $result |awk '{print $3}'`
echo LOG_SEC_DCSPNCK: MB_ID: max=$ret

result=`${SQLCMD}<<EOF
select nvl(max(MB_ID),0) from LOG_SEC_SCOSPRSC;
EOF`

ret=`echo $result |awk '{print $3}'`
echo LOG_SEC_SCOSPRSC: MB_ID: max=$ret

result=`${SQLCMD}<<EOF
select nvl(to_char(max(LAST_UPDATE_DATE), 'yyyy-MM-dd HH24:mi:ss'), '1900-01-01 00:00:00') as curr_max from LOG_SEC_LKXXB;
EOF`

ret=`echo $result | awk '{printf("%s %s", $3,$4);}'`
echo LOG_SEC_LKXXB: LAST_UPDATE_DATE: max=$ret

result=`${SQLCMD}<<EOF
select nvl(to_char(max(LAST_UPDATE_DATE), 'yyyy-MM-dd HH24:mi:ss'), '1900-01-01 00:00:00') as curr_max from LOG_SEC_AJXXB;
EOF`

ret=`echo $result | awk '{printf("%s %s", $3,$4);}'`
echo LOG_SEC_AJXXB: LAST_UPDATE_DATE: max=$ret

result=`${SQLCMD}<<EOF
select nvl(max(ID),0) from BARCODE_RECORD;
EOF`

ret=`echo $result |awk '{print $3}'`
echo BARCODE_RECORD: ID: max=$ret

