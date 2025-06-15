#!/bin/bash

gcc -o hello.fcgi fcgi_server.c -lfcgi 

spawn-fcgi -p 8080 hello.fcgi  

nginx
echo "\n"
echo "localhost:81 page:"
curl localhost:81
echo "\n"

# command to help kill lsof -i -P | grep LISTEN | grep :80