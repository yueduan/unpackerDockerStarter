#!/bin/bash

for id in $(sudo docker ps | grep "droidscope_new:version2" | awk '{print $1}')
do
	echo "=========== Checking $id ============"
	sudo docker exec $id /bin/sh -c "ls -l /results/; ls /results/| wc -l"
done
