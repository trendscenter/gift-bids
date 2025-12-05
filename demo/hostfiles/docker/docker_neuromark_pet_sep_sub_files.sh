#!/bin/bash

# TReNDS 12/4/2025 Cyrus Eierud
# Script that works if each subject has its own PET file.
# subject nii-files has to be under a directory called input_sbm, 
#    and supports that each subject may be in a sub-directory 
#    (e.g., BIDS standard). All subjects have to have a unique 
#    file name.
# Note that this script does not work is all subjects are merged 
#    into a single (4D) nii-file

# example: ./docker_neuromark_pet_sep_sub_files.sh /mypath/mysubjects /mypath/myoutput /mypath/cfg
# 

# DIR_IN directory contains single 3d nii-file per subject
DIR_IN=$1 
DIR_OUT=$2
DIR_CFG=$3

# Create the 4D file
# Copy subjects in 3D format to create 4D nii
mkdir ${DIR_OUT}
mkdir ${DIR_OUT}"/input_sbm"
cp -r $DIR_IN $DIR_OUT"/input_sbm/."

# Organizing subjects for GIFT
docker run -ti --rm \
    -v $DIR_OUT:/out \
    -v $DIR_CFG:/cfg \
    -v /tmp/:/work \
    --entrypoint /cfg/icatb/icatb_sbm_merge_nii.sh nipreps/fmriprep


# RUN SBM
docker run -ti --rm \
  -v /tmp:/tmp \
  -v /var/tmp:/var/tmp \
  -v ${DIR_CFG}"/icatb/misc/bids_dummy/":/data:ro \
  -v $DIR_OUT:/out \
  -v $DIR_CFG:/cfg \
  trends/gift-bids:v4.0.5.3 \
    /data /out participant \
    --config /cfg/input_neuromark_pet.m


# Exports NII (of time course) to CSV
docker run -ti --rm \
    -v $DIR_OUT:/out \
    -v $DIR_CFG:/cfg \
    -v /tmp/:/work \
    --entrypoint /cfg/icatb/icatb_nii2csv.sh nipreps/fmriprep

exit 0

