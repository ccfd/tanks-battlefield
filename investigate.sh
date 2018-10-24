#!/bin/bash

#set -e

source settings.sh
source lib.sh

$OKSH list_org_repos ccfd-class _filter='.[] | "\(.updated_at)\t\(.owner.login)\t\(.name)"' >list0.log
$OKSH list_forks ccfd tanks     _filter='.[] | "\(.updated_at)\t\(.owner.login)\t\(.name)"' >>list0.log

cat list0.log | grep 'tanks[^ \t]*$' >list.log

if test -f last.log
then
	LAST="$(cat last.log)"
else
	LAST=0
fi
NOW=$LAST

TASK=""


while read DATE USER REPO
do
	if test "$USER" == "ccfd-class"
	then
		NAME="$REPO"
	else
		NAME="$REPO-$USER-fork"
	fi
	pending "Repo: $REPO"
	SDATE=$(date -d "$DATE" +%s)
	test "$NOW" -lt "$SDATE" && NOW="$SDATE"

	if test "$LAST" -lt "$SDATE"
	then
		success " NEW "
		./update.sh $DRY $USER $REPO $NAME
	else
		success " OLD "
	fi
done <list.log

echo $NOW >last.log
