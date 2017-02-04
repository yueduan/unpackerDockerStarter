#!/bin/bash


for id in $(sudo docker ps | grep "droidscope_new:version2" | awk '{print $1}')
do
	echo "Getting remaining app list from $id"
	sudo docker exec $id /bin/sh -c "cd /test_apps/; ls | wc -l"
done
