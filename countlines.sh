NLINES=$( cat $1 | wc -l)
if [[ $NLINES -gt 1 ]]; then echo $1 has $NLINES lines; elif [[ $NLINES -eq 1 ]]; then echo $1 has $NLINES line; else echo $1 is empty; fi

