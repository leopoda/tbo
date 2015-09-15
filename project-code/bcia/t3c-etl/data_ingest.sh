#!/bin/bash

# ./imp_tab1.sh &
# ./imp_tab2.sh &
./imp_tab3.sh >> log/log_lkxxb-`date +%Y%m%d`.txt 2>&1 &
./imp_tab4.sh >> log/log_ajxxb-`date +%Y%m%d`.txt 2>&1 &
./imp_tab5.sh >> log/log_barcode-`date +%Y%m%d`.txt 2>&1 &
./imp_tab6.sh >> log/log_apdb_pid-`date +%Y%m%d`.txt 2>&1 &

sleep 1
while true
do
  result=`ps -ef | grep imp_tab | head -n 1 |grep -v 'grep'`
  if [ "$result" != "" ]; then
    sleep 1
  else
    export start_dt=`./calc-start-dt.sh gat` && export end_dt=`./calc-end-dt.sh` && ./populate-gat.sh >> log/log_gat-`date +%Y%m%d`.txt 2>&1 &
    export start_dt=`./calc-start-dt.sh sck` && export end_dt=`./calc-end-dt.sh` && ./populate-sck.sh >> log/log_sck-`date +%Y%m%d`.txt 2>&1 &
    break
  fi
done

sleep 1
while true
do
  result=`ps -ef | grep populate | head -n 1 | grep -v 'grep'`
  if [ "$result" != "" ]; then
    sleep 1
  else
    break
  fi
done

rm -rf ./*.java
