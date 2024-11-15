
# ARGUMENTS SETTING
if [[ -z $1 ]]; then X="."; else X=$1; fi # set of folder X where to search files
if [[ -z $2 ]]; then N="0"; else N=$2; fi # set of number N of lines

FILES=$(find $X -type f -name "*.fa" -or -name "*.fasta")
if [[ -z $FILES ]]
	then echo "No fa/fasta files found in $X"
else
	# REPORT
	echo "========== SUMMARY OF FA/FASTA FILES IN $X AND SUBDIRECTIORIES =========="
	echo "-> Total fa/fasta files found: $(echo $FILES | wc -w)"
	echo -e "-> Unique fasta IDs found: $(grep -h '^>' $FILES | awk '{print $1}' | sort | uniq | wc -l) \n"


	for FILE in $FILES
		# header
		do if [[ -h $FILE ]]; then SYM=symlink; else SYM="not symlink"; fi # symbolic link check
		SEQ=$(grep '^>' $FILE | wc -l) # number of sequences
		# TYPE=  file of amino acids or nucleotides check
		# LEN= total sequence length
		echo "========== SUMMARY OF $FILE ($SYM, $SEQ, $LEN, $TYPE) =========="
		# file content
	done

fi