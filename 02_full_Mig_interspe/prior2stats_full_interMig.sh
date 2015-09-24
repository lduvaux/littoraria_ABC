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
#$ -t 1-5

# set the environment variable TIMECOUNTER to 0, then start the chrono
export TIMECOUNTER=0
source timeused

## 0) Print miscellaneous variables for the log file
echo "## 0) Print miscellaneous variables for the log file"
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

## 1) set simulation variables
printf "\n## 1) set simulation variables\n"
nrep=500    # number of datasets to be simulated
nloc=1000    # number of loci to simulate per dataset
mini=1  # minimum number of SNPs (S) to be observed in simulated alignments
maxi=4  # maximum number of SNPs (S) to be observed in simulated alignments
N_ite=15 # max number of ms iterations in order to observe the right number of SNP for a given alignment
thres=1 # maximum number of simuls with S < mini or maxi > 4 (1%)
suthr=1Pc   # suffix for output, 1Pc -> 6e2/6e4


## 2) run simulations
printf "\n## 2) run simulations\n"
    # 2.1) set file names
rand_seed=${taskid}${jobid}
echo "random seed:"
printf "${rand_seed}"

suf=full_interspeMig.${jobid}.${taskid}
ms_out=ms-ali_${suf}.txt

    # 2.2) run simulations
printf "\n./runSim.sh full_interspeMig.jl ${rand_seed} ${suf}"
./runSim.sh full_interspeMig.jl ${nrep} ${nloc} ${rand_seed} ${suf} ${mini} ${maxi} ${N_ite} ${ms_out}


## 3) compute stats
printf "\n## 3) compute stats\n"
msums -i spinput_${suf}.txt -S all -o ABCstat_${suf}.txt
gzip spinput_${suf}.txt
gzip ABCstat_${suf}.txt


## 4) check number of incorrect datasets
printf "\n## 4) check number of incorrect datasets\n"
grep "segsites" ${ms_out} > N_segsites_${suf}.txt
gzip N_segsites_${suf}.txt
rm ${ms_out}
printf "N_segsites_locus.jl N_segsites_${suf}.txt.gz Badsimul_thres${suthr}_${suf}.txt.gz ${thres} ${nloc} ${mini} ${maxi}\n"
N_segsites_locus.jl N_segsites_${suf}.txt.gz Badsimul_thres${suthr}_${suf}.txt.gz ${thres} ${nloc} ${mini} ${maxi} 


## z) display time
printf "\n##  display time\n"
date
source timeused
