#!/bin/bash
#SBATCH --job-name=SRA_download
#SBATCH --partition=short
#SBATCH --export=ALL
#SBATCH --nodes 1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem 32G
#SBATCH --time 24:00:00
#SBATCH --out=/scratch/sun.xinh/singlecellrna/project3/logs/%x_%j.log
#SBATCH --err=/scratch/sun.xinh/singlecellrna/project3/logs/%x_%j.err
#SBATCH --mail-type=ALL   # get email updates about the job
#SBATCH --mail-user=sun.xinh@northeastern.edu

##### the number of sra exceeds the maximum number of array size
##SBATCH --array=1-768 # Change to represent the total number of samples in your file
################################################################################
# Download fastq files from SRA for PRJNA436229.
# 2023-06-14
################################################################################

if [ $# -lt 2 ]
then
    echo "need a samples file (sra number) and a start number"
    exit 1 
fi

##### VARIABLES #####

# Destination directory where files will be downloaded.
DEST_DIR=/scratch/$USER/singlecellrna/project3/data

# Change this to the path where you stored your samples list
ACC_FILE=/scratch/$USER/singlecellrna/project3/$1
OFFSET=$2
NUM_ROW=$((OFFSET + SLURM_ARRAY_TASK_ID + 1))
#echo ${NUM_ROW}
ACC_NUM=$(sed "${NUM_ROW}q;d" ${ACC_FILE})
echo Downloding ${ACC_NUM}

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

# If 10X, Rename files for further use
#mv ${DEST_DIR}/${ACC_NUM}_1.fastq.gz ${DEST_DIR}/${ACC_NUM}_S1_L001_I1_001.fastq.gz
#mv ${DEST_DIR}/${ACC_NUM}_2.fastq.gz ${DEST_DIR}/${ACC_NUM}_S1_L001_R1_001.fastq.gz
#mv ${DEST_DIR}/${ACC_NUM}_3.fastq.gz ${DEST_DIR}/${ACC_NUM}_S1_L001_R2_001.fastq.gz
