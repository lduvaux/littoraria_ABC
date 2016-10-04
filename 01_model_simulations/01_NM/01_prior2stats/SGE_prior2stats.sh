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
#$ -t 1-1020

# set the environment variable TIMECOUNTER to 0, then start the chrono
export TIMECOUNTER=0
source timeused


## 0) set simulation variables
model=NM
printf "\n## 1) set simulation variables\n"
nrep=1000   # number of datasets to simulate
nloc=29623  # number of loci to simulate per dataset
mini=1      # minimum number of SNPs (S) to be observed in simulated alignments
maxi=4      # maximum number of SNPs (M) to be observed in simulated alignments
N_ite=30    # maximum number of ms iterations in order to observe the right number of SNPs for a given alignment
thres=296   # maximum number of simulations with segsites < mini or > maxi
suthr=1Pc   # suffix for output


## 1) Print miscellaneous variables for the log file
echo "## 0) Print miscellaneous variables for the log file"
#logname=${SGE_O_LOGNAME}
jobid=${JOB_ID} ; taskid=${SGE_TASK_ID} ; host=${HOSTNAME} ; wd=`basename $PWD`
date
echo "# host: ${host}"
echo "# Jobid: ${jobid}"
echo "# taskid: ${taskid}"
echo "# working directory: ${PWD}"; echo ""


## 2) run simulations
printf "\n## 2) run simulations\n"
    # 2.1) set file names
rand_seed=${taskid}${jobid}
echo "random seed: ${rand_seed}"; echo ""

suf=${model}.${jobid}.${taskid}
ms_out=ms-ali_${suf}.txt

    # 2.2) run simulations
printf "\n./runSim.sh ${model}.jl ${rand_seed} ${suf}"
./runSim.sh ${model}.jl ${nrep} ${nloc} ${rand_seed} ${suf} ${mini} ${maxi} ${N_ite} ${ms_out}


## 3) compute stats
printf "\n## 3) compute stats\n"
msums -i spinput_${suf}.txt -S all -o ABCstat_${suf}.txt
gzip spinput_${suf}.txt
    # remove column 'dataset' and compress
cut -f2- ABCstat_${suf}.txt | gzip > ABCstat_${suf}.txt.gz
rm ABCstat_${suf}.txt


## 4) check number of incorrect datasets
printf "\n## 4) check number of incorrect datasets\n"
grep "segsites" ${ms_out} > N_segsites_${suf}.txt
gzip N_segsites_${suf}.txt
rm ${ms_out}
N_segsites_locus.jl N_segsites_${suf}.txt.gz ${model} Badsimul_thres${suthr}_${suf}.txt.gz ${thres} ${nloc} ${mini} ${maxi} ${jobid} ${taskid}


## z) display time
printf "\n##  display time\n"
date
source timeused
