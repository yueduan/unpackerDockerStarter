#!/bin/bash


for id in $(sudo docker ps -a -q)
do
	echo "Getting remaining app list from $id"
	sudo docker exec $id /bin/sh -c "cd /test_apps/; ls | wc -l"
done
