#!/bin/bash


################################################################################
# This Bash script is help to submit to Slurm in the number of sra exceeds 
# the maximum number of array size
# Download fastq files from SRA for PRJNA436229. !YOUR SRA NUMBER
# Author: Xinhao Sun
# 2023-06-14
################################################################################

##### VARIABLES #####
if [ $# -lt 1 ]
then
    echo "need a samples file (sra number)"
    exit 1 
fi
# Destination directory where files will be downloaded.
DEST_DIR=/scratch/$USER/singlecellrna/project2/data

# Change this to the path where you stored your samples list
ACC_FILE=/scratch/$USER/singlecellrna/project2/$1

######

if [[ ! -e $ACC_FILE ]]; then
    echo "File $ACC_FILE does not exist."
    exit 2
fi 

# Create the destination directory.
mkdir -p ${DEST_DIR}


# Calculate total number of samples and set the max array size
TOTAL_SAMPLES=$(wc -l < $ACC_FILE)

echo "Number of sra is $TOTAL_SAMPLES" 

MAX_ARRAY_SIZE=500
OFFSET=0

while [[ $TOTAL_SAMPLES -gt 0 ]]
do
    LIMIT=$(( TOTAL_SAMPLES > MAX_ARRAY_SIZE ? MAX_ARRAY_SIZE - 1 : TOTAL_SAMPLES - 1 ))
    sbatch --array=0-$LIMIT 1_sra_download.sh $1 $OFFSET
    OFFSET=$((OFFSET + (LIMIT + 1) ))
    TOTAL_SAMPLES=$(( TOTAL_SAMPLES - (LIMIT + 1) ))
done
