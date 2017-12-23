#!/bin/bash

cmd=$@

PID=`cat /var/run/server.pid`

echo "$cmd" > /proc/$PID/fd/0
