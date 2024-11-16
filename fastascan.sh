
# ARGUMENTS SETTING
if [[ -z $1 ]]; then X="."; echo "! No folder specified as the first argument. Default: $X"; else X=$1; fi # set of folder X where to search files
if [[ -z $2 ]]; then N="0"; echo -e "! No number of lines specified as the second argument. Default: $N \n"; else N=$2; fi # set of number N of lines

FILES=$(find $X -type f -name "*.fa" -or -name "*.fasta")
if [[ -z $FILES ]]
	then echo "No fa/fasta files found in $X"
else
	# REPORT
	echo "========== SUMMARY OF FA/FASTA FILES IN $X AND SUBDIRECTORIES =========="
	echo "-> Total fa/fasta files found: $(echo $FILES | wc -w)"
	echo -e "-> Unique fasta IDs found: $(grep -h '^>' $FILES | awk '{print $1}' | sort | uniq | wc -l) \n"


	for FILE in $FILES

		# HEADER
		do if [[ -h $FILE ]]; then SYM="SYMLINK"; else SYM="NOT SYMLINK"; fi # symbolic link check
		NSEQ=$(grep '^>' $FILE | wc -l) # number of sequences

		SEQ=$(grep -v '^>' $FILE | sed 's/[- ]//g' | tr -d '\n') # grep lines that do not start by >, deleting "-", \n and spaces
		LEN=$(echo -n $SEQ | wc -c) # count characters from $SEQ (total sequence length)
		# TYPE=  file of amino acids or nucleotides check

		echo "========== SUMMARY OF $FILE: $SYM, Nº SEQUENCES: $NSEQ, TOTAL SEQUENCE LENGTH: $LEN, $TYPE =========="

		# FILE CONTENT
		if [[ $N != 0 ]] 
			then if [[ $(cat $FILE | wc -l) -le $((2*$N)) ]]
				then cat $FILE
				else head -n $N $FILE && echo … && tail -n $N $FILE
			fi
		else continue
		fi
	done
fi


### CONTROLS: is a file empty?, does $X exist? (add messages for controls????), Ns in nucleotide file?
### TYPE!!