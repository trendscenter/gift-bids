#!/bin/bash

# Nov 2023 TReNDS
# Simple HMC processing head motion correction 
# SLURM array across 191 subject

#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=20g
#SBATCH -p qTRD
#SBATCH -t 1440
#SBATCH -J <SLURM-HMC-PET>
#SBATCH -e error%A.err
#SBATCH -o out%A.out
#SBATCH -A trends53c17
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<hpetropoulos@gsu.edu>
#SBATCH --oversubscribe

sleep 10s

module add fsl/6.0.6.5
module add freesurfer/7.4.1
module add python/3.9.9

cd /root/petprep_hmc/petprep_hmc

python3 ./run.py --bids_dir /root/data_fbb/bids111423helen --output_dir /root/data_fbb/bids111423helen/derivatives/petprep_hmc/ --analysis_level participant

sleep 30s
