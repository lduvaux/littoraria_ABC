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
#$ -t 1-60

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
echo "# jobid:"
echo $jobid
echo "# taskid:"
echo $taskid

## 1) set simulation variables
printf "\n## 1) set simulation variables\n"
model=full_interspeMig
nrep=1750	# number of datasets to be simulated
nloc=29623	# number of loci to simulate per dataset
mini=1		# minimum number of SNPs (S) to be observed in simulated alignments
maxi=4		# maximum number of SNPs (M) to be observed in simulated alignments
N_ite=20	# maximum number of msnseg iterations in order to observe the right number of SNP for a given alignment
thres=296	# maximum number of simulations with S < mini or maxi > M (1%)
suthr=1Pc	# suffix for output, 1Pc -> 6e2/6e4

## 2) run simulations
printf "\n## 2) run simulations\n"
    # 2.1) set file names
rand_seed=${taskid}${jobid}
echo "random seed:"
printf "${rand_seed}"

suf=${model}.${jobid}.${taskid}
ms_out=ms-ali_${suf}.txt

    # 2.2) run simulations
printf "\n./runSim.sh ${model}.jl ${rand_seed} ${suf}"
./runSim.sh ${model}.jl ${nrep} ${nloc} ${rand_seed} ${suf} ${mini} ${maxi} ${N_ite} ${ms_out}

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
