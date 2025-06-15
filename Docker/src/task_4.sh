#!/bin/bash

docker build -t server:1.0 . 

docker run -d -p 80:81 server:1.0

sleep .5
echo "\n"
echo "Hostname page:"
curl 127.0.0.1
echo "\n"
echo "Status page:"
curl 127.0.0.1/status
echo "\n"