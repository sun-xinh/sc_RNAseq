#!/bin/bash\
#SBATCH --job-name=sort_and_index
#SBATCH --partition=short
#SBATCH -N 1       # number of nodes
#SBATCH -n 8       # number of cores
#SBATCH --mem 50G  # memory for all cores
#SBATCH --time=02:00:00
################################################################################
# Sort and index genome BAM files created by STAR using samtools.
# https://github.com/alexdobin/STAR
# http://www.htslib.org/
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

# Name of sample to process.
# Your assigned sample
SAMPLE=SAMN12212513

# Full path to directory where genome BAM files are stored.
BAM_DIR=/scratch/${USER}/binf6201/results/rsem

# Name of BAM file in the BAM_DIR.
BAM_FILE=${BAM_DIR}/${SAMPLE}.genome.bam

# Temporary directory where intermediate files will be stored.
TEMP_DIR=/scratch/${USER}/temp

### PROGRAM ###

# Sort and index the BAM file.

echo Sorting ${BAM_FILE}

samtools sort -@ 8 \
    -T ${TEMP_DIR} \
    -o ${BAM_FILE}_sorted.bam ${BAM_FILE}

echo Indexing ${BAM_FILE}

samtools index ${BAM_FILE}_sorted.bam

##############################################################
################### DANGER DANGER DANGER #####################
# If you delete this file and you're not done with it, you'll 
# have to regenerate it with the previous script. Once you're
# certain that the sorting and indexing worked correctly, you 
# can uncomment this line and run it.
# In the long run, we DO want to delete unneeded BAM file.
# They take up space and we'll never look at them.

# Remove the unsorted BAM file.
#rm ${BAM_FILE}

##############################################################
##############################################################