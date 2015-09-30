## 0) set variables
    # PLS transform script
pls_transf=true
nb_pls=20
pls_fil="./Routput_full_interspeMig.txt"
stat_files1="./ABCstat_full_interspeMig.1961048.1.txt.gz"
stat_files2="./ABCstat_full_interspeMig.1961048.1_formatted.txt.gz"

    # Regression R script
reg_script=ABC_PLS-Regression


## 1) Print miscellaneous variables for the log file
echo "## 1) Print miscellaneous variables for the log file"
jobid=${JOB_ID} ; taskid=${SGE_TASK_ID} ; host=${HOSTNAME} ; wd=`basename $PWD`# ; logname=${SGE_O_LOGNAME}
date
echo "# host: ${host}"
#echo "# logname: ${logname}"
echo "# Jobid: ${jobid}"
echo "# taskid: ${taskid}"
echo "# working directory: ${PWD}"; echo ""


## 2) PLS transform original stats
echo "## 2) PLS transform original stats"

if [ -z $pls_transf ]; then
    echo "Option 'pls_transf' not specified:"
    echo "  Do you want to PLS transform the original data?" 
    echo "    Please specify 'pls_transf=true' or 'pls_transf=false'"
    echo "    in section '## 0) set variables' of the SGE script" 
    exit
elif [ ${pls_transf} = true ]; then
    echo "./PLS_transform.sh -n ${nb_pls} -p ${pls_fil} -s ${stat_files}"
    ./PLS_transform.sh -n ${nb_pls} -p ${pls_fil} -s ${stat_files1}
    echo ""

    echo "./PLS_transform.sh -n ${nb_pls} -p ${pls_fil} -s ${obs_stats}"
    ./PLS_transform.sh -n ${nb_pls} -p ${pls_fil} -s ${stat_files2}
elif [ ${pls_transf} = false ]; then
    echo "WARNING: the files with the original statistics were not processed"
    echo "  for PLS transformation. Are you sure that:"
    echo "    - you specified the option 'pls_transf' correctly (current value: ${pls_transf})" 
    echo "    - the files with transformed statistics were already present" ; echo ""
else
    echo "Option 'pls_transf' badly specified:"
    echo "    Please specify 'pls_transf=true' or 'pls_transf=false'"
    echo "    in section '## 0) set variables' of the SGE script" 
fi
