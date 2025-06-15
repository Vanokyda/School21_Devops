#!/bin/bash

 gcc -o hello.fcgi fcgi_server.c -lfcgi
 
 service nginx start
 
 nginx -s reload
 
 spawn-fcgi -p 8080 hello.fcgi
 
 nginx -g 'daemon off;'
 
 sleep infinity