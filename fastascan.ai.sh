#!/bin/bash
# ARGUMENTS SETTING
# set of folder X where to search files:
if [[ -z $1 ]]; then X="."; echo "[INFO] No folder specified as the first argument. Default: $X"; else X=$1; fi
if [[ ! -d $X ]]; then echo "[ERROR] $X is not an existing directory"; exit 1; fi # control: is X a directory?

# set of number N of lines
if [[ -z $2 ]]; then N=0; echo "[INFO] No number of lines specified as the second argument, files content will not be displayed. Default: $N"; else N=$2; fi 
if ! [[ $N =~ ^[0-9]+$ ]]; then echo "[ERROR] N can't be a negative or non-integer"; exit 1; fi # control: is N negative or non-integer?

FILES=""
for FILE in $(find $X -type f -iname "*.fa" -or -iname "*.fasta"); do
	if [[ -r $FILE && -s $FILE ]]; then # control: do FILES have reading permissions?
        	FILES="$FILES $FILE"
	else echo "[WARNING] Skipping unreadable or empty file: $FILE" 
	fi
done

if [[ -z $FILES ]]; then echo "[ERROR] No fa/fasta files found in $X"; exit 1; fi # control: there are fa/fasta files in the directory?

# REPORT
echo -e "\n========== SUMMARY OF FA/FASTA FILES IN $X AND SUBDIRECTORIES =========="
echo "-> Total fa/fasta files found: $(echo $FILES | wc -w)"
echo "-> Unique fasta IDs found: $(awk '/^>/{print $1}' $FILES | sort -u | wc -l)"

for FILE in $FILES; do echo

	# HEADER

	# symbolic link check:
	[[ -h $FILE ]] && SYM="SYMLINK" || SYM="NOT SYMLINK"

	# count lines starting by > (number of sequences):
	NSEQ=$(grep -c "^>" $FILE) 

	### 
	SEQ=$(awk '!/^>/{gsub(/[ -]/, ""); seq=seq $0} END{print seq}' $FILE)
	### 

	# count characters from sequence lines deleting - and spaces (total sequence length):
	LEN=$(echo $SEQ | awk '{len+=length($0)} END{print len}') 

	# file of amino acids or nucleotides check:
	if echo $SEQ | grep -qm 1 "[^AaTtGgCcUuNn]"; then TYPE="AA FILE"; else TYPE="NUC FILE"; fi			

	echo "========== SUMMARY OF $FILE: $SYM, Nº SEQUENCES: $NSEQ, TOTAL SEQUENCE LENGTH: $LEN, $TYPE =========="

	# FILE CONTENT
	if [[ $N -eq 0 ]]; then continue; fi
	if [[ $(cat $FILE| wc -l) -le $((2*$N)) ]]; then cat $FILE
	else head -n $N $FILE; echo …; tail -n $N $FILE
	fi
done
