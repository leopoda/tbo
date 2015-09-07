#!/bin/bash

. ./config.sh

rm -rf $deploy_dir
mkdir -p $deploy_dir

cp ./*.sh $deploy_dir
cp ./*.xml $deploy_dir
cp ./*.sql $deploy_dir

rm -rf $deploy_dir/deploy.sh
rm -rf $deploy_dir/trunc_tabs.sh

