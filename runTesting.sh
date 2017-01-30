#!/bin/bash

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
