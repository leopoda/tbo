#!/bin/bash

. ./config.sh

rm -rf $deploy_dir
mkdir -p $deploy_dir
mkdir -p $deploy_dir/log

cp ./*.sh $deploy_dir
cp ./*.xml $deploy_dir

./create_stagedb.sh

rm -rf $deploy_dir/deploy.sh
rm -rf $deploy_dir/trunc_tabs.sh
