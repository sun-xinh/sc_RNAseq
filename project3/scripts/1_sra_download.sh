#!/bin/bash
#SBATCH --job-name=SRA_download
#SBATCH --partition=short
#SBATCH --export=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=16  # Change this to represent the number of tasks (downloads) you want to run in parallel
#SBATCH --mem 32G
#SBATCH --time 24:00:00
#SBATCH --out=/scratch/sun.xinh/singlecellrna/project1/logs/%x_%j.log
#SBATCH --err=/scratch/sun.xinh/singlecellrna/project1/logs/%x_%j.err
#SBATCH --mail-type=ALL   # get email updates about the job
#SBATCH --mail-user=sun.xinh@northeastern.edu
#SBATCH --array=1-768%16  # This will start a new job for every 16 SRA files
################################################################################
# Download fastq files from SRA for PRJNA436229.
# 2023-06-14
################################################################################

##### VARIABLES #####

# Destination directory where files will be downloaded.
DEST_DIR=/scratch/$USER/singlecellrna/project2/data

# Change this to the path where you stored your samples list
ACC_FILE=/scratch/$USER/singlecellrna/project2/samples_file.txt

######

# Create the destination directory.
mkdir -p ${DEST_DIR}

# Load up the working environment
module load anaconda3/2021.11
source activate BINF-01-2023
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Loop over the SRA files and run fastq-dump in parallel
for i in $(seq 0 $(($SLURM_ARRAY_TASK_ID+15))); do
    ACC_NUM=$(sed "${i}q;d" ${ACC_FILE})

    # Download files.
    fastq-dump \
        --dumpbase \
        --readids \
        --split-files \
        --gzip \
        --outdir ${DEST_DIR} \
        ${ACC_NUM} &
done

# Wait for all background jobs to finish
wait

