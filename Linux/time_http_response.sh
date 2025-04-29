#!/bin/bash

start=$(date +%s)

curl http://www.google.com

stop=$(date +%s)

let total_time=stop-start

echo $total_time

#curl command used

