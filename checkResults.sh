#!/bin/bash

for id in $(sudo docker ps -q)
do
	echo "=========== Checking $id ============"
	sudo docker exec $id /bin/sh -c "ls -l /results/; ls /results/| wc -l"
done
