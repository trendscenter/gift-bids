#!/bin/bash

# Nov 2023 TReNDS
# Regular FreeSurfer processing
# A job array was set up with a size of 100. 190 subjects successfully completed analysis. 
# QC was carried out visually.

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --array=0-37
#SBATCH --mem=20g
#SBATCH -p qTRD
#SBATCH -t 1440
#SBATCH -J <PET_FBB_FS>
#SBATCH -e error%A.err
#SBATCH -o out%A.out
#SBATCH -A trends53c17
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<hpetropoulos@gsu.edu>
#SBATCH --oversubscribe

sleep 10s

# Some of the code here has been borrowed from https://rcs.ucalgary.ca/Freesurfer_on_ARC#Multiple_Scans_Reconstruction_in_Parallel_with_a_Job_Array

module add freesurfer/7.4.1
source $FREESURFER_HOME/SetUpFreeSurfer.sh

((i=SLURM_ARRAY_TASK_ID-1))

subjects_file=/root/data_fbb/freesurfer/fsT1forFbb/scripts/subjects_list.txt
if [ ! -e "${subjects_file}" ]; then
  >&2 echo "error: subjects_file does not exist"
  exit 1
fi

# read the subjects from the subjects file
IFS=$'\n'; subjects=( $(cat "${subjects_file}") );

subject=${subjects[${i}]}
subject_id=`basename $subject .nii`
subjects_dir=/root/data_fbb/freesurfer/fsT1forFbb
output_dir=/root/data_fbb/derivatives/freesurfer/

recon-all -subjid ${subject_id} -i ${subjects_dir}/${subject} -all -sd ${output_dir}

sleep 30s

