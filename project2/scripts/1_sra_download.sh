#!/bin/bash
#SBATCH --job-name=SRA_download
#SBATCH --partition=short
#SBATCH --export=ALL
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --mem 32G
#SBATCH --time 24:00:00
#SBATCH --out=/scratch/sun.xinh/singlecellrna/project1/logs/%x_%j.log
#SBATCH --err=/scratch/sun.xinh/singlecellrna/project1/logs/%x_%j.err
#SBATCH --mail-type=ALL   # get email updates about the job
#SBATCH --mail-user=sun.xinh@northeastern.edu
#SBATCH --array=1-768 # Change to represent the total number of samples in your file
################################################################################
# Download fastq files from SRA for PRJDB3966.
# 2023-06-14
################################################################################

##### VARIABLES #####

# Destination directory where files will be downloaded.
DEST_DIR=/scratch/$USER/singlecellrna/project2/data

# Change this to the path where you stored your samples list
ACC_FILE=/scratch/$USER/singlecellrna/project2/samples_file.txt
ACC_NUM=$(sed "${SLURM_ARRAY_TASK_ID}q;d" ${ACC_FILE})

######

# Create the destination directory.
mkdir -p ${DEST_DIR}

# Load up the working environment
module load anaconda3/2021.11
source activate BINF-01-2023
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8



# Download files.
fastq-dump \
    --dumpbase \
    --readids \
    --split-files \
    --gzip \
    --outdir ${DEST_DIR} \
    ${ACC_NUM}

# Rename files for further use
mv ${DEST_DIR}/${ACC_NUM}_1.fastq.gz ${DEST_DIR}/${ACC_NUM}_S1_L001_I1_001.fastq.gz
mv ${DEST_DIR}/${ACC_NUM}_2.fastq.gz ${DEST_DIR}/${ACC_NUM}_S1_L001_R1_001.fastq.gz
mv ${DEST_DIR}/${ACC_NUM}_3.fastq.gz ${DEST_DIR}/${ACC_NUM}_S1_L001_R2_001.fastq.gz
