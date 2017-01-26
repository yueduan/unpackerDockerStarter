#!/bin/bash


dir=$1
docker=$2

for file in $dir/*apk
do
	sudo docker cp $file $docker:/test_apps
done
