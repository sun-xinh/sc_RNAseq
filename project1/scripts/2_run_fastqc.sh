#!/bin/bash
#SBATCH --job-name=RUN_Fastqc
#SBATCH --partition=short
#SBATCH --export=ALL
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --mem 32G # memory pool for all cores
#SBATCH --time 8:00:00 # time (D-HH:MM)
#SBATCH --out=/scratch/sun.xinh/singlecellrna/project1/logs/%x_%j.log
#SBATCH --err=/scratch/sun.xinh/singlecellrna/project1/logs/%x_%j.err
#SBATCH --mail-type=ALL   # get email updates about the job
#SBATCH --mail-user=sun.xinh@northeastern.edu
################################################################################
# Perform quality control on FASTQ files using FastQC.
# https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
# 
# Xinhao Sun
# 2023-07-13
################################################################################

### Environment ###
module load anaconda3/2021.11
source activate BINF-01-2023
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

### VARIABLES ###
CLASS_DIR=/scratch/${USER}/singlecellrna/project1

# Full path to the FASTQ file directory.
FASTQ_DIR=${CLASS_DIR}/data

# Full path to the FastQC output directory.
OUTPUT_DIR=${CLASS_DIR}/results/fastqc
# Make dir for output
mkdir -p ${OUTPUT_DIR}

### PROGRAM ###

# Run FastQC on all Read files,except L1 or L2 files
fastqc --outdir ${OUTPUT_DIR} ${FASTQ_DIR}/*{R1,R2}*.fastq.gz
                              
# Run MultiQC on all FastQC files. -f for rerun if error
multiqc -f --outdir ${OUTPUT_DIR} ${OUTPUT_DIR}
