#!/bin/bash

# ./imp_tab1.sh
# ./imp_tab2.sh
./imp_tab3.sh
./imp_tab4.sh
./imp_tab5.sh
./imp_tab6.sh

export start_dt=`./calc-start-dt.sh gat` && export end_dt=`./calc-end-dt.sh` && ./populate-gat.sh
export start_dt=`./calc-start-dt.sh sck` && export end_dt=`./calc-end-dt.sh` && ./populate-sck.sh

rm -rf ./*.java
