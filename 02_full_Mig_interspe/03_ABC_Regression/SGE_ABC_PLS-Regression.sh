#!/bin/bash

# specify the interpreting shell for the job
#$ -S /bin/bash
# merge mean and error ouputs
#$ -j y
# execute the job from the current working directory
#$ -cwd
# specifiy that all environment variables active within the qsub utility be exported to the context of the job
#$ -V
# request memory for job
#$ -l mem=6G
#$ -l rmem=6G
# specify the architecture of the node in which the job should run, so to avoid using the incompatible node
#$ -l arch=intel*
# run time for job in hours:mins:sec (max 168:0:0, jobs with h_rt < 8:0:0 have priority)
# $ -l h_rt=7:59:59
# submit an array of t identical tasks being only differentiated by an index number
#$ -t 1-1

# set the environment variable TIMECOUNTER to 0, then start the chrono
export TIMECOUNTER=0
source timeused


## 0) set variables
    # PLS transform script
pls_transf=true
nb_pls=20
pls_fil="../02_PLS_transformation/Routput_full_interspeMig.txt"
stat_files="../01_prior2stats/ABCstat_full_interspeMig.1961048.*"

    # Regression R script
reg_script=ABC_PLS-Regression


## 1) Print miscellaneous variables for the log file
echo "## 0) Print miscellaneous variables for the log file"
#logname=${SGE_O_LOGNAME}
jobid=${JOB_ID} ; taskid=${SGE_TASK_ID} ; host=${HOSTNAME} ; wd=`basename $PWD`
date
echo "# host: ${host}"
echo "# Jobid: ${jobid}"
echo "# taskid: ${taskid}"
echo "# working directory: ${PWD}"; echo ""


## 2) PLS transform original stats
echo "## 2) PLS transform original stats"
if [ -z $runtransf ]; then
    echo "Do you want to PLS transform the original data?" 
    echo "    You have to specify 'pls_transf=true' or 'pls_transf=false'"
    echo "    in section '## 0) set variables'" 
    exit
elif [ ${runtransf} = true ]; then
    echo "./PLS_transform.sh -n ${nb_pls} -p ${pls_fil} -s ${stat_files}"
    ./PLS_transform.sh -n ${nb_pls} -p ${pls_fil} -s ${stat_files}
else
    echo "WARNING: the files with the original statistics were not processed"
    echo "  for PLS transformation. Are you sure that:"
    echo "    - you specified the option 'runtransf' correctly (current value: ${runtransf})" 
    echo "    - the files with transformed statistics were already present" ; echo ""
fi


## 3) perform regression
echo "## 3) perform regression"
R CMD BATCH ${reg_script}.R ${reg_script}.${jobid}.log


# display time
echo "# display time"
date
source timeused
