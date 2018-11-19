#!/bin/bash

function quiet_run {
	if ! "$@" >tmp.log 2>&1
	then
		echo "Error in:" "$@"
		cat tmp.log
		echo "-----"
		return -1
	else
		return 0
	fi
}

if test "$1" == "dry"
then
	echo "Making a dry run"
	DRY="dry"
	function dry_run {
		echo "Would run:" "$@"
	}
	shift
else
	DRY=""
	function dry_run {
                quiet_run "$@"
        }
fi

function pending {
	printf '%-50s [       ]\b\b\b\b\b\b\b' "$1"
#	echo -ne '  [       ]\b\b\b\b\b\b\b'
}

function success {
	echo -ne "\e[92m$1\e[0m\n"
}

function fail {
	echo -ne "\e[91m$1\e[0m\n"
}

function slow_write {
	while IFS='' read -d '' -n1 c
	do
		T=$[10000 + ($RANDOM % 200)]
		sleep 0.${T:2:3}
		echo -n "$c"
	done < <(echo "$@")
}
