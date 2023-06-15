#!/bin/bash
#SBATCH --job-name=rsem_quant
#SBATCH --partition=short
#SBATCH -N 1       # number of nodes
#SBATCH -n 8       # number of cores
#SBATCH --mem 50G  # memory for all cores
#SBATCH --time=02:00:00
################################################################################
# Use RSEM & STAR to estimate gene counts aligned to GRCm39.
# Previously, we used STAR to align our reads to the genome. Now we will use
# RSEM to estimate the number of reads that align to each gene. This will
# produce counts for each gene (or transcript) in the genome.
#
# Your Name
# YYYY-MM-DD
################################################################################
### Environment ###
module load anaconda3/2021.11
source activate BINF-01-2023
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

### VARIABLES ###

# The prefix for the sample we wish to process.
# Put your assigned sample here
SAMPLE=SAMN12212513

# Directory for RSEM/STAR index.
GENOME_DIR_PREFIX=/work/courses/binf6201/GRCm39/rsem_index/rsem_index

# STAR output directory.
STAR_DIR=/scratch/${USER}/binf6201/results/star

# RSEM output directory.
OUTPUT_DIR=/scratch/${USER}/binf6201/results/rsem

# Temporary working directory.
TEMP_DIR=/scratch/${USER}/temp

### PROGRAM ###

# Create the output directory.
mkdir -p ${OUTPUT_DIR} ${TEMP_DIR}

echo Aligning sample ${SAMPLE}

# Quantify gene counts with RSEM.
BAM_FILE=${STAR_DIR}/${SAMPLE}_Aligned.toTranscriptome.out.bam

rsem-calculate-expression \
    --paired-end \
    --num-threads 8 \
    --alignments \
    --estimate-rspd \
    --append-names \
    --output-genome-bam \
    ${BAM_FILE} \
    ${GENOME_DIR_PREFIX} \
    ${OUTPUT_DIR}/${SAMPLE}