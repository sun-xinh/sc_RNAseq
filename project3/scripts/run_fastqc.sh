#!/bin/bash


################################################################################
# This Bash script is help to submit to Slurm in the number of .fastq files exceeds 
# the maximum number of array size

# Author: Xinhao Sun
# 2023-06-14
################################################################################

##### VARIABLES #####
IN_DIR=/scratch/$USER/singlecellrna/project3

######

# make a file to store all names of .fastq files in IN_DIR
ls ${IN_DIR}/data/*.{fastq,fastq.gz} >fastq_names.txt 2>/dev/null

# Calculate total number of samples and set the max array size
TOTAL_FASTQ=$(wc -l < ${IN_DIR}/fastq_names.txt)

echo "Number of sra is $TOTAL_FASTQ" 

MAX_ARRAY_SIZE=500
OFFSET=0

while [[ $TOTAL_FASTQ -gt 0 ]]
do
    LIMIT=$(( TOTAL_FASTQ > MAX_ARRAY_SIZE ? MAX_ARRAY_SIZE - 1 : TOTAL_FASTQ - 1 ))
    sbatch --array=0-$LIMIT 2_fastqc_sbatch.sh fastq_names.txt $OFFSET
    OFFSET=$((OFFSET + (LIMIT + 1) ))
    TOTAL_FASTQ=$(( TOTAL_FASTQ - (LIMIT + 1) ))
done
