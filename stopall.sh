#!/bin/bash

for id in $(sudo docker ps | grep "droidscope_new:version2" | awk '{print $1}')
do 
	echo "stop $id"
	sudo docker exec $id /bin/sh -c "killall -9 adb; killall -9 python; killall -9 emulator64-arm"
done
