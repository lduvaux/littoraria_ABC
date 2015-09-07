#!/bin/bash
# run platypus for target contigs

## set up bash and envt options
# Specifies the interpreting shell for the job.
#$ -S /bin/bash
# merge mean and error ouputs
#$ -j y
# Execute the job from the current working directory.
#$ -cwd
# Specifies that all environment variables active within the qsub utility be exported to the context of the job
#$ -V

## Job settings
# request memory for job (default 6G, max 72G)
#$ -l mem=6G
#$ -l rmem=6G

# run time for job in hours:mins:sec (max 168:0:0, jobs with h_rt < 8:0:0 have priority)
# $ -l h_rt=7:59:59

# number of CPUs to use
# -pe openmp 6
# Submits an array of 80 identical tasks being only differentiated by an index number
#$ -t 1-80

# set the environment variable TIMECOUNTER to 0, then start the chrono
export TIMECOUNTER=0
source timeused

## 0) Print miscellaneous variables for the log file
echo "## 0) Print mis variables for the log file"
#logname=${SGE_O_LOGNAME}
jobid=${JOB_ID}
taskid=${SGE_TASK_ID}
host=${HOSTNAME}
wd=`basename $PWD`

date
echo "# host:"
echo $host
echo "# Jobid:"
echo $jobid
echo "# taskid:"
echo $taskid


## 1) run simulations
printf "\n## 1) run simulations"
rand_seed=${taskid}${jobid}
echo "random seed:"
printf "${rand_seed}"

suf=full_interspeMig.${jobid}.${taskid}
printf "\n./runSim.sh full_interspeMig.jl ${rand_seed} ${suf}"
./runSim.sh full_interspeMig.jl ${rand_seed} ${suf}


## 2) parse ms output file
printf "\n## 2) parse ms output file"
#WARNING - TODO
    #- parse the ms outputs
    #- write a modified ms output
    #- modify prior file accordingly
    #- write a modified spinput (to compute stats)


## 3) compute sats
printf "\n## 3) compute sats"
msums -i spinput_${suf}.txt -S all -o ABCstat_${suf}.txt


## z) display time
printf "\n##  display time\n"
date
source timeused
