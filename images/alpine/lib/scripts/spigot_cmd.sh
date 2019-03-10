#!/bin/bash

cmd=$@

PID=`cat $RUN_DIR/$APP_NAME.pid`

echo "$cmd" > $RUN_DIR/$PID.input
