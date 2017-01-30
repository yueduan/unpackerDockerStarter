#!/bin/bash


DATE=`date +%Y-%m-%d`

mkdir $DATE

for id in $(sudo docker ps -a -q)
do
	echo "Retriving results from $id"
	#sudo docker exec $id /bin/sh -c "find /results -name others.log | xargs rm"
	sudo docker exec $id /bin/sh -c "tar cf results_$id.tar.gz /results"
	sudo docker cp $id:/results_$id.tar.gz .
	sudo docker exec $id /bin/sh -c "rm -rf /results/*; rm results_$id.tar.gz"
	mv results_$id.tar.gz $DATE/	
done
