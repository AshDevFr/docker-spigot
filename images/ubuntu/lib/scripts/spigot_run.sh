#!/bin/bash

cmd="$@"

echo $$ > $RUN_DIR/$APP_NAME.pid
rm -f $RUN_DIR/$$.input
mkfifo $RUN_DIR/$$.input

echo "Starting $cmd with pid $$"
exec $cmd < <(tail -f $RUN_DIR/$$.input)
