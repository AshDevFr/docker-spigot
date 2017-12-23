#!/bin/sh

name=$1
shift
cmd="$@"

mkdir -p /minecraft/run
echo $$ > /minecraft/run/$name.pid

echo "Starting $cmd with pid $$"
exec $cmd
