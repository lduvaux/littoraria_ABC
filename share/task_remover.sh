#!/bin/bash

#$ -S /bin/bash
#$ -j y
#$ -cwd
#$ -V
#$ -l mem=6G
#$ -l rmem=2G
#$ -l h_rt=7:59:59
#$ -t 1-14

taskid=${SGE_TASK_ID}
tasks=`less tasks_to_remove.txt`
task=`echo $tasks | cut -d" " -f$taskid`

rm -f *2219736.$task*
