#!/bin/bash

#Cleans docker container (one) and image named server:1.0

CONTAINER_ID="$(docker ps -a | grep server | awk '{print $1}')"

docker stop $CONTAINER_ID

docker rm $CONTAINER_ID

docker rmi server:1.0