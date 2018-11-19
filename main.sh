#!/bin/bash
set -e

clear

while true
do
	if ! ./run.sh "$@"
	then
		sleep 10
	fi
done
