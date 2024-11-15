if [[ -z $2 ]]; then LINES=3; else LINES=$2; fi
if [[ $(cat $1 | wc -l) -le $((2*$LINES)) ]]; then cat $1; else echo "===== More than $((2*$LINES)) lines in $1, showing first and last $LINES lines ====="; head -n $LINES $1 && echo … && tail -n $LINES $1; fi
