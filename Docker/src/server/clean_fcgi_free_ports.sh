#!/bin/bash

rm -rf *.fcgi

TARGET=$(lsof -i -P | grep LISTEN | grep :8080 | awk '{print $2}')

kill -9 $TARGET

nginx -s stop

echo "lsof -i -P | grep LISTEN | grep :80 RESULT:"
lsof -i -P | grep LISTEN | grep :80
echo "\n"
echo "lsof -i -P | grep LISTEN | grep :81 RESULT:"
lsof -i -P | grep LISTEN | grep :81
echo "\n"