#!/bin/bash

# Nov 2023 TReNDS
# PETPrep was run on 190 subjects successfully using SLURM array
# Some subjects did not complete unless memory was increased to 30GB

#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=20g
#SBATCH -p qTRD
#SBATCH -t 1440
#SBATCH -J <PETPrep>
#SBATCH -e error%A.err
#SBATCH -o out%A.out
#SBATCH -A trends53c17
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<hpetropoulos@gsu.edu>
#SBATCH --oversubscribe

sleep 10s

module add fsl/6.0.6.5
module add freesurfer/7.4.1
module add python/3.9.9
module add matlab/R2019b

export SUBJECTS_DIR=/root/data_fbb/bids111423helen/derivatives/freesurfer
cd /root/data_fbb/bids111423helen/code

matlab -nodesktop -nosplash -r "PETPrep('/root/data_fbb/bids111423helen/', 'config.json');exit;"

sleep 30s
