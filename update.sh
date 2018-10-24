#!/bin/bash
set -e

source settings.sh
source lib.sh

USER="$1"
if test -z "$USER"
then
	echo "Provide the user name"
	exit -1;
fi
shift

REPO="$1"
if test -z "$REPO"
then
	echo "Provide the repo name"
	exit -1;
fi
shift

NAME="$1"
if test -z "$NAME"
then
	echo "Provide the path name"
	exit -1;
fi
shift

mkdir -p repos

pending "$NAME"
if test -d "repos/$NAME"
then
	success " PULL"
	quiet_run pushd repos/$NAME
	quiet_run git pull
else
	success "CLONE"
	quiet_run git clone "https://github.com/$USER/$REPO.git" repos/$NAME
	quiet_run pushd repos/$NAME
fi

quiet_run popd
