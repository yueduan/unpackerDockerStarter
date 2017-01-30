#!/bin/bash


DATE=`date +%Y-%m-%d`

mkdir $DATE



for id in $(sudo docker ps -a -q)
do 
	echo "Retriving results from $id"
	sudo docker exec $id /bin/sh -c "tar cf results_$id.tar.gz /results"
	sudo docker cp $id:/results_$id.tar.gz .
	sudo docker exec $id /bin/sh -c "rm -rf /results/*; rm results_$id.tar.gz"
	mv results_$id.tar.gz $DATE/	

	echo "restarting $id"
	sudo docker exec $id /bin/sh -c "killall -9 adb; killall -9 python; killall -9 emulator64-arm"
	sudo docker exec $id /bin/bash -c "cd /unpackerAutoTestingScripts;git pull"	
	sudo docker exec $id /bin/bash -c "python /unpackerAutoTestingScripts/unpackerAutoTesting.py &" &
done
