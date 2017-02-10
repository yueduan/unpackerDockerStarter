#!/bin/bash

declare -A retVal1
declare -A retVal2


for ((i=1;i<=5;i++));
do
        # start a new docker container
        sudo nohup docker run -itd -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix droidscope_new:version2
        id=$(sudo docker ps -l -q)

        sudo docker exec $id /bin/bash -c "cd /unpackerAutoTestingScripts;git pull"

        # copy apps over
        ./copyAppsOver.sh $i $id

        echo "running tests on $id"
        sudo docker exec $id /bin/bash -c "python /unpackerAutoTestingScripts/unpackerAutoTesting.py &" &
done

sleep 200

while :
do
        for id in $(sudo docker ps | grep "droidscope_new:version2" | awk '{print $1}')
        do
                retVal1[$id]=$(sudo docker exec $id /bin/sh -c "ls /results | wc -l")
                echo "$id: ${retVal1[$id]}"
        done

        sleep 1000

        for id in $(sudo docker ps | grep "droidscope_new:version2" | awk '{print $1}')
        do
                retVal2[$id]=$(sudo docker exec $id /bin/sh -c "ls /results | wc -l")
                echo "$id: ${retVal2[$id]}"
        done

        for id in $(sudo docker ps | grep "droidscope_new:version2" | awk '{print $1}')
        do
                dif=$((${retVal2[$id]} - ${retVal1[$id]}))
                if [ $dif -eq 0 ]
                then
			appRemain=$(sudo docker exec $id /bin/sh -c "ls /test_apps | wc -l")
			if [ $appRemain -ne 0 ]
			then
                        	echo "no progress for $id, restarting!"
				sudo docker exec $id /bin/sh -c "killall -9 adb; killall -9 python; killall -9 emulator64-arm"
				sudo docker exec $id /bin/bash -c "cd /unpackerAutoTestingScripts;git pull"
				sudo docker exec $id /bin/bash -c "python /unpackerAutoTestingScripts/unpackerAutoTesting.py &" &			
                	fi
		fi
        done

done
