#!/bin/bash -e
#SBATCH --job-name=AtomsCavityBasisDemo # job name (shows up in the queue)
#SBATCH --time=0:10:00      # Walltime (HH:MM:SS)
#SBATCH --mem=512MB          # Memory in MB
#SBATCH --qos=debug          # debug QOS for high priority job tests

module purge
module load Python

python AtomsCavityBasisDemo.py
