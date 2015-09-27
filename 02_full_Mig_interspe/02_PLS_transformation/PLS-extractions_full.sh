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

logname=${SGE_O_LOGNAME}
jobid=${JOB_ID}
taskid=${SGE_TASK_ID}
host=${HOSTNAME}

#wd=`pwd`
date
echo $host

# script R
fil=PLS-extraction
R CMD BATCH ${fil}.R ${fil}.${jobid}.log

# display time
echo "# display time"
date
source timeused
