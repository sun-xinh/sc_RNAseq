#!/bin/bash
################################################################################
# Run MultiQC on existing FastQC files to summarize all results.
# https://multiqc.info/
#
# Your Name
# YYYY-MM-DD
################################################################################

### VARIABLES ###
module load anaconda3/2021.11
source activate BINF-01-2023

# Full path to the FastQC directory.
FASTQC_DIR=/scratch/${USER}/binf6201/results/fastqc/

### PROGRAM ###

# Run MultiQC on all FastQC files.
multiqc ${FASTQC_DIR}
