#!/bin/bash

#SBATCH --partition=reservation
#SBATCH --reservation=bootcamp_cpu_2023
#SBATCH --job-name=sample_slurm_job
#SBATCH --time=00:05:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --output=%j.out

# Access the first argument
echo "The first argument is: $1"

# Access the second argument
echo "The second argument is: $2"

# Access the third argument
echo "The third argument is: $3"

