#!/bin/sh

name=$1
shift
cmd="$@"

echo $$ > /var/run/$name.pid

echo "Starting $cmd with pid $$"
exec $cmd
