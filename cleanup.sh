#!/bin/bash

sudo docker stop $(sudo docker ps | grep "droidscope_new:version2" | awk '{print $1}')
sudo docker rm $(sudo docker ps -a | grep "droidscope_new:version2" | awk '{print $1}')
