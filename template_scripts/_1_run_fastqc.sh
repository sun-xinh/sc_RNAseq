#!/bin/bash
################################################################################
# Perform quality control on FASTQ files using FastQC.
# https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
# 
# Your Name
# YYYY-MM-DD
################################################################################

### VARIABLES ###
CLASS_DIR=/work/courses/binf6201
SAMPLE= # Put your assigned sample here

# Full path to the FASTQ files.
FASTQ_FILE_R1=${CLASS_DIR}/fastq_merged/${SAMPLE}_1.fastq.gz
FASTQ_FILE_R2=${CLASS_DIR}/fastq_merged/${SAMPLE}_2.fastq.gz

# Full path to the FastQC output directory.
OUTPUT_DIR=/scratch/${USER}/binf6201/results/fastqc
mkdir -p $OUTPUT_DIR

### PROGRAM ###
module load anaconda3/2021.11
source activate BINF-01-2023

# Run FastQC on FASTQ files.
fastqc --outdir ${OUTPUT_DIR} ${FASTQ_FILE_R1} ${FASTQ_FILE_R2}