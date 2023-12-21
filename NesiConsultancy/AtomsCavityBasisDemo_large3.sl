#!/bin/bash -e
#SBATCH --job-name=AtomsCavityBasisDemo # job name (shows up in the queue)

#SBATCH --time=02:00:00      # Walltime (HH:MM:SS)
#SBATCH --mem=32GB          # Memory in GB
#SBATCH --cpus-per-task=4   # number of threads

blas=""
venv=""
while getopts "b:e:" flag
do
    case "${flag}" in
       b) blas=${OPTARG};;
       e) venv=${OPTARG};;
    esac
done
echo "blas=$blas"
echo "venv=$venv"

module purge
module load Python

# load MKL if desired
if [ "$blas" == "mkl" ]; then
    module load imkl
fi
module list

# user must specify the virtual environment
if [ -d "$venv" ]; then
    echo "Loading $venv environment"
    source ${venv}/bin/activate
else
    echo "ERROR: you need to specify a virtual environment (-e VENV)"
    exit 1
fi

# check if using MKL
python -c "import qutip;qutip.about()"

# run
python AtomsCavityBasisDemo.py -c ./Configs/largeconfig3.ini 

