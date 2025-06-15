#!/bin/bash

#Cleans docker container (one) and image named server:1.0

CONTAINER_ID1="$(docker ps -a | grep task_5_server | awk '{print $1}')"

docker stop $CONTAINER_ID1

docker rm $CONTAINER_ID1

CONTAINER_ID2="$(docker ps -a | grep task_5_proxy | awk '{print $1}')"

docker stop $CONTAINER_ID2

docker rm $CONTAINER_ID2

docker rmi task_5_proxy
docker rmi task_5_server

docker ps -a
docker images