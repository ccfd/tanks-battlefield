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

if test "$[$RANDOM % 6]" -lt 1
then
	OPTS="$OPTS -x"
fi

OPTS="$OPTS -o $[$RANDOM % 5]"

cd tanks
rsync -a /home/vncuser/grading/tanks-players/ src/
slow_run make
make players.txt
cat players.txt | grep -v "KeyboardPlayer" >bots.txt
test -f "bots.txt"
BOTS="$(shuf -n 2 bots.txt)"
echo
slow_run ./main $OPTS $BOTS 2>/dev/null | tee out.log
cat out.log | grep "^Results:" | tail -n 1 | sed 's|^Results:||' >> ../results.log
