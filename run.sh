#!/bin/bash
set -e

source settings.sh
source lib.sh

function slow_run {
	echo -n " > "
	slow_write "$@"
	"$@"
}

#BOTS="$(shuf -n 2 bots.txt)"

OPTS="$OPTS -o $[$RANDOM % 5]"

cd tanks
rsync -au /home/vncuser/grading/tanks-players/ src/
echo
slow_run make
make players.txt >/dev/null 2>&1
cat players.txt | grep -v "KeyboardPlayer" >bots.txt
test -f "bots.txt"
BOTS="$(shuf -n 2 bots.txt)"

case "$[$RANDOM % 6]" in
0)	OPTS="$OPTS -x";;
1)	BOTS="$(echo $BOTS | sed 's|\([^ ]*\)|\1:2|g')";;
esac

#BOTS="$(shuf -n 4 bots.txt | sed 's|\([^ ]*\)|\1:2|g')"

echo
(cd ..; elo/elo <results.log | tee elo.txt)
if test -f "../elo.txt"
then
	OPTS="$OPTS -b ../elo.txt:16"
fi
echo
slow_run ./main $OPTS $BOTS 2>/dev/null | tee out.log
cat out.log | grep "^Results:" | tail -n 1 | sed 's|^Results:||' | sed "s|\$| $(date +%s)|" >> ../results.log
