#!/bin/bash
# Specifies the interpreting shell for the job.
#$ -S /bin/bash
# merge mean and error ouputs
#$ -j y
# Execute the job from the current working directory.
#$ -cwd
# run time for job in hours:mins:sec (max 168:0:0, jobs with h_rt < 8:0:0 have priority)
#$ -l h_rt=7:59:59
# request memory for job (default 6G, max 72G)
#$ -l mem=16G
#$ -l rmem=12G
# Defines or redefines under which circumstances mail is to be sent to the job owner (non-activated)
# -m beas
# -M l.duvaux@sheffield.ac.uk
# Specifies that all environment variables active within the qsub utility be exported to the context of the job
#$ -V
# Submits an array of identical tasks being only differentiated by an index number
# and being treated by Grid Engine almost like a series of jobs.
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

# load R
module load apps/R

# script R
fil=Regression_ABC
R CMD BATCH ${fil}.R ${fil}.${jobid}.log

# display time
echo "# display time"
date
source timeused	
