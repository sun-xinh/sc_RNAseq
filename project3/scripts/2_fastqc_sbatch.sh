#!/bin/bash
#SBATCH --job-name=RUN_Fastqc
#SBATCH --partition=short
#SBATCH --export=ALL
#SBATCH --nodes 1
#SBATCH --cpus-per-task=1
#SBATCH --mem 32G # memory pool for all cores
#SBATCH --time 8:00:00 # time (D-HH:MM)
#SBATCH --out=/scratch/sun.xinh/singlecellrna/project3/logs/%x_%j.log
#SBATCH --err=/scratch/sun.xinh/singlecellrna/project3/logs/%x_%j.err
#SBATCH --mail-type=ALL   # get email updates about the job
#SBATCH --mail-user=sun.xinh@northeastern.edu


################################################################################
# Perform quality control on FASTQ files using FastQC.
# https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
# 
# Xinhao Sun
# 2023-07-13
################################################################################

if [ $# -lt 2 ]
then
    echo "need a fastq names file (fastq names) and a start number"
    exit 1 
fi

### Environment ###
module load anaconda3/2021.11
source activate BINF-01-2023
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

### VARIABLES ###
CLASS_DIR=/scratch/${USER}/singlecellrna/project3

# Full path to the FASTQ file directory.
ACC_FILE=${CLASS_DIR}/$1
OFFSET=$2
NUM_ROW=$((OFFSET + SLURM_ARRAY_TASK_ID))
FASTQ_NUM=$(sed "${NUM_ROW+1}q;d" ${ACC_FILE})

# Full path to the FastQC output directory.
OUTPUT_DIR=${CLASS_DIR}/results/fastqc
# Make dir for output
mkdir -p ${OUTPUT_DIR}

### PROGRAM ###

# Run FastQC on all Read files,except L1 or L2 files
fastqc --outdir ${OUTPUT_DIR} ${CLASS_DIR}/data/${FASTQ_NUM}
                              
# Run MultiQC on all FastQC files. -f for rerun if error
#multiqc -f --outdir ${OUTPUT_DIR} ${OUTPUT_DIR}
