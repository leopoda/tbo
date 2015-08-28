#!/bin/bash

./create_schema.sh
./imp_tab1.sh
./imp_tab2.sh
./imp_tab3.sh
./imp_tab4.sh
./imp_tab5.sh

rm -rf ./*.java
