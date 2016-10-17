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
#$ -l h_rt=7:59:59
# submit an array of t identical tasks being only differentiated by an index number
#$ -t 1-1

# set the environment variable TIMECOUNTER to 0, then start the chrono
export TIMECOUNTER=0
source timeused


## 0) set variables
    # PLS transform script
pls_transf=true
nb_pls=15
pls_fil="../02_PLS_transformation/Routput_CM.txt"
stat_files="../01_prior2stats/ABCstat_CM.*"
obs_stats="../../ABCstat_observed_formatted.txt.gz"

    # Regression R script
reg_script=ABC_PLS-Regression


## 1) Print miscellaneous variables for the log file
echo "## 1) Print miscellaneous variables for the log file"
jobid=${JOB_ID} ; taskid=${SGE_TASK_ID} ; host=${HOSTNAME} ; wd=`basename $PWD`# ; logname=${SGE_O_LOGNAME}
date
echo "# host: ${host}"
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
    ./PLS_transform.sh -n ${nb_pls} -p ${pls_fil} -s ${stat_files}
    echo ""

    echo "./PLS_transform.sh -n ${nb_pls} -p ${pls_fil} -s ${obs_stats}"
    ./PLS_transform.sh -n ${nb_pls} -p ${pls_fil} -s ${obs_stats}
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


## 3) perform regression
echo "## 3) perform regression"
obs_transf=`basename ${obs_stats%.txt.gz}.transf.txt.gz`
Rscript ${reg_script}.R ${nb_pls} ${obs_transf} 2>&1 > ${reg_script}.${jobid}.log


# display time
echo "# display time"
date
source timeused
