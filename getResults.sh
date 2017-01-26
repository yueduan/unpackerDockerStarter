#!/bin/bash


for id in $(sudo docker ps -a -q)
do
	echo "Retriving results from $id"
	sudo docker exec $id /bin/sh -c "find /results -name others.log | xargs rm"
	sudo docker exec $id /bin/sh -c "tar cf results_$id.tar.gz /results"
	sudo docker cp $id:/results_$id.tar.gz .
done
