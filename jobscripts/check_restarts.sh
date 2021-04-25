if [ $# -eq 0 ]
then
    echo "ERROR: please specify format file"
    echo "   ex: ./runens.sh spinAD.env"
    exit 1
fi

#set up environment variables
source $1
jobdir=$(pwd)"/"

rejects=$jobdir$codebase"/"$ensname"_"$runtype"_rejects2.txt"
echo $rejects

casekeys="/glade/u/home/djk2120/clm5ppe/jobscripts/PPEn08/configs/CTL2010_SASU_rejects_casekeys.txt"

failedrun=0

while read -r casekey; do 
    p=$casePrefix"_"$casekey
    cd $SCRIPTS_DIR$ensname"/"$casePrefix"/"$p

    keyfile=$p"_key.txt"
    d=$SCRATCH$p"/run/"
        while read -r line; do 
	tmp=(${line///}) 
	paramkey=${tmp[1]} 
	instkey=${tmp[0]}

	if [ $ninst -gt 1 ]; then
	    inst="_"$instkey
	fi
	oldfile=$d$p".clm2"$inst".r.*"
	newfile=$RESTARTS$ensname"_"$paramkey$finidatSuff
	if [ -f $oldfile ]; then
	    echo $paramkey" is good"
	    #cp $oldfile $newfile
	    #echo "cp "$oldfile" "$newfile
	    #cp $oldfile $newfile
	else
	    echo $paramkey" MAY HAVE FAILED"
	    echo "CASE="$p
	    failedrun=1
	    echo $paramkey >> $rejects
	fi
    done < $keyfile
done < $casekeys

