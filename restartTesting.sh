#!/bin/bash

DATE=`date +%Y-%m-%d`

mkdir $DATE

declare -A retVal1
declare -A retVal2

for id in $(sudo docker ps -q)
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

sleep 200

while :
do
        for id in $(sudo docker ps -q)
        do
                retVal1[$id]=$(sudo docker exec $id /bin/sh -c "ls /results | wc -l")
                echo "$id: ${retVal1[$id]}"
        done

        sleep 1000

        for id in $(sudo docker ps -q)
        do
                retVal2[$id]=$(sudo docker exec $id /bin/sh -c "ls /results | wc -l")
                echo "$id: ${retVal2[$id]}"
        done

        for id in $(sudo docker ps -q)
        do
                dif=$((${retVal2[$id]} - ${retVal1[$id]}))
                if [ $dif -eq 0 ]
                then
                        echo "no progress for $id, restarting!"
			sudo docker exec $id /bin/sh -c "killall -9 adb; killall -9 python; killall -9 emulator64-arm"
			sudo docker exec $id /bin/bash -c "cd /unpackerAutoTestingScripts;git pull"
			sudo docker exec $id /bin/bash -c "python /unpackerAutoTestingScripts/unpackerAutoTesting.py &" &			
                fi
        done

done
