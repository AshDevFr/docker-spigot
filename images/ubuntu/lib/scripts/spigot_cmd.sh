#!/bin/bash

cmd=$@

PID=`cat /minecraft/run/server.pid`

echo "$cmd" > /proc/$PID/fd/0
