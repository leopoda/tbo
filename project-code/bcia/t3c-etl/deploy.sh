#!/bin/bash

. ./config.sh

rm -rf $deploy_dir
mkdir -p $deploy_dir
mkdir -p $deploy_dir/log

cp ./*.sh $deploy_dir
cp ./*.xml $deploy_dir

./create_stagedb.sh

rm -rf $deploy_dir/deploy.sh
rm -rf $deploy_dir/trunc_data.sh
rm -rf $deploy_dir/tab-max.sh
rm -rf $deploy_dir/barcode-max.sh

rm -rf $deploy_dir/imp_tab1.sh
rm -rf $deploy_dir/imp_tab2.sh
