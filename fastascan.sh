
# ARGUMENTS SETTING
# set of folder X where to search files:
if [[ -z $1 ]]; then X="."; echo "[INFO] No folder specified as the first argument. Default: $X"; else X=$1; fi

# set of number N of lines
if [[ -z $2 ]]; then N="0"; echo "[INFO] No number of lines specified as the second argument. Default: $N"; else N=$2; fi 

if [[ -d $X ]]; then # control: is X a directory?
	echo
	FILES=$(find $X -type f -name "*.fa" -or -name "*.fasta") 
	if [[ -z $FILES ]]; then # control: there are fa/fasta files in the directory?
		echo "[ERROR] No fa/fasta files found in $X"
	else
		# REPORT
		echo "========== SUMMARY OF FA/FASTA FILES IN $X AND SUBDIRECTORIES =========="
		echo "-> Total fa/fasta files found: $(echo $FILES | wc -w)"
		echo "-> Unique fasta IDs found: $(awk '/>/{print $1}' $FILES | sort | uniq | wc -l)"
		

		for FILE in $FILES; do echo
			if [[ -s $FILE ]]; then # control: is FILE empty?

				# HEADER
				
				# symbolic link check:
				if [[ -h $FILE ]]; then SYM="SYMLINK"; else SYM="NOT SYMLINK"; fi 

				# count lines starting by > (number of sequences):
				NSEQ=$(awk '/>/{nseq+=1}END{print nseq}' $FILE) # $(grep '>' $FILE | wc -l) wc adds a lot of spaces in output
				
				##	
				SEQ=$(awk '!/>/{gsub(/[ -]/, "",$0); seq = seq $0}END{print seq}' $FILE) 
				###

				# count characters from sequence lines deleting - and spaces (total sequence length):
				LEN=$(echo $SEQ | awk '{len+=length($0)}END{print len}') 

				# file of amino acids or nucleotides check:
				TYPE=$(if echo $SEQ | grep -q "[^AaTtGgCcUuNn]"; then echo "Aminoacids file"; else echo "Nucleotides file"; fi) # !!!!!!-m 1 in grep?			

				echo "========== SUMMARY OF $FILE: $SYM, Nº SEQUENCES: $NSEQ, TOTAL SEQUENCE LENGTH: $LEN, $TYPE =========="

				# FILE CONTENT
				if [[ $N != 0 ]]; then
					if [[ $(cat $FILE | wc -l) -le $((2*$N)) ]]; then cat $FILE; echo
					else head -n $N $FILE; echo …; tail -n $N $FILE; echo
					fi

				else continue
				fi

			else echo -e "[WARNING] $FILE is empty \n"
			fi
		done
	fi
else echo "[ERROR] $X is not an existing directory"
fi

### CONTROLS: file permissions??? , Ns in nucleotide file?, fasta headers????, what if N is a negative number?
