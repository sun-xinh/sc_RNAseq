#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=StarAlignment
#SBATCH -N 1              # number of nodes
#SBATCH -n 8              # number of cores
#SBATCH --mem 50G         # memory for all cores
#SBATCH -t 02:00:00       # time (HH:MM::SS)
#SBATCH --mail-type=ALL   # get email updates about the job
#SBATCH --mail-user=user.name@northeastern.edu

################################################################################
# Align the reads in the FASTQ files to the mouse genome, informed by the 
# mouse transcripts.
# https://github.com/alexdobin/STAR
#
# Your Name
# YYYY-MM-DD
################################################################################
module load anaconda3/2021.11
source activate BINF-01-2023

### VARIABLES ###

# Full path to the directory where FASTQ files are stored.
FASTQ_DIR=/work/courses/binf6201/fastq

# Full path to the directory where the STAR genome index is stored.
GENOME_DIR=/work/courses/binf6201/GRCm39/rsem_index

# Sample name.
SAMPLE=SAMN12212513

# FASTQ filename 1.
FASTQ_FILE1=${FASTQ_DIR}/${SAMPLE}_1.fastq.gz

# FASTQ filename 2.
FASTQ_FILE2=${FASTQ_DIR}/${SAMPLE}_2.fastq.gz

# Full path to the directory where STAR output will be written.
OUTPUT_DIR=/scratch/${USER}/binf6201/results/star

### PROGRAM ###

echo Aligning sample ${SAMPLE}

STAR --runThreadN 8 \
   --readFilesIn ${FASTQ_FILE1} ${FASTQ_FILE2} \
   --readFilesCommand zcat \
   --genomeDir ${GENOME_DIR} \
   --alignSJoverhangMin 20 \
   --alignSJDBoverhangMin 1 \
   --outFilterMismatchNmax 4 \
   --outFileNamePrefix ${OUTPUT_DIR}/${SAMPLE}_ \
   --outFilterType BySJout \
   --outSAMtype BAM SortedByCoordinate \
   --outSAMattributes Standard \
   --quantMode TranscriptomeSAM
