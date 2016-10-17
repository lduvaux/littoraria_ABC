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
#$ -l mem=6G # max 128G
#$ -l rmem=2G # max 48G
# run time for job in hours:mins:sec (max 168:0:0, jobs with h_rt < 8:0:0 have priority)
#$ -l h_rt=7:59:59
# submit an array of t identical tasks being only differentiated by an index number
#$ -t 1-20
# notification settings
#$ -m bea
#$ -M mauricio.montano.rendon@gmail.com

# set the environment variable TIMECOUNTER to 0, then start the chrono
export TIMECOUNTER=0
source timeused


## 0) set variables
    # Cross validation R script
R_script=cross_valid_ABC


## 1) Print miscellaneous variables for the log file
echo "## 1) Print miscellaneous variables for the log file"
jobid=${JOB_ID} ; taskid=${SGE_TASK_ID} ; host=${HOSTNAME} ; wd=`basename $PWD`#
date
echo "# host: ${host}"
echo "# jobid: ${jobid}"
echo "# taskid: ${taskid}"
echo "# working directory: ${PWD}"; echo ""


## 2) perform cross validation
echo "## 2) perform cross validation"
Rscript ${R_script}.R ${jobid} ${taskid}


# display time
echo "# display time"
date
source timeused
