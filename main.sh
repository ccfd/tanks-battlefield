#!/bin/bash
set -e

source settings.sh
source lib.sh

function slow_run {
	echo -n " > "
	slow_write "$@"
	"$@"
}

cd tanks

clear

while true
do
slow_run make
slow_run ./main -t 60 SimpleBot SimpleBot
done
