#!/bin/bash
# Demo script of Group Independent Component Analysis (gift) BIDS-App, 
# using BIDS-App data (16 subjects) and fMRIPrep
# Version 1.000
# Cyrus Eierud, TReNDS

# Please note that before running this demo the following is needed:
#
# 1) Install Docker (https://www.docker.com/products/personal).
#
# 2) Open terminal, create and go to working directory of your choice.
#
# 3) Clone or unzip the https://github.com/trendscenter/gift-bids repository 
#    to the root of your working directory.
#
# 4) Download the ds005.tar dataset from 
# https://drive.google.com/drive/folders/0B2JWN60ZLkgkMGlUY3B4MXZIZW8?resourcekey=0-EYVSOlRbxeFKO8NpjWWM3w 
#     into your working directory (step 2). This ds005.tar dataset is 
#    described at the BIDS App tutorial web page 
#    (https://bids-apps.neuroimaging.io/tutorial).
#
# 5) If you do not have a free FreeSurfer license you need to apply for 
#    the license file by registering according with the link 
#    https://surfer.nmr.mgh.harvard.edu/registration.html and then place 
#    your FreeSurfer license.txt file into your working directory.
#
# 6) Finally this script (gift-bids-demo.sh) may be run in terminal by:
#    chmod +x gift-bids-demo.sh
#    ./gift-bids-demo.sh
#
# After this Docker will download images for fmriprep and trends/gift-bids 
# containers. It will then run fmriprep for a single subject which may 
# take 2h or more. Finally trends/gift-bids will run for at least 5 min.
#
# Results are found under ds005-gift-out directory

# Sanity check before run
FILE=ds005.tar
if [ ! -f "$FILE" ]; then
    echo "Error! Missing $FILE at the root of the working directory. "
    echo " $FILE may be downloaded from: "
    echo " https://drive.google.com/drive/folders/0B2JWN60ZLkgkMGlUY3B4MXZIZW8?resourcekey=0-EYVSOlRbxeFKO8NpjWWM3w" 
    exit 10
fi
FILE=license.txt
if [ ! -f "$FILE" ]; then
    echo "Error! Missing $FILE at the root of the working directory."
    echo " $FILE is obtained for free from: "
    echo " https://surfer.nmr.mgh.harvard.edu/registration.html"
    exit 10
fi

# set up subject and data files before run
tar -xf ds005.tar

# Get current directory
TR_PWD=`pwd`

# Downloads the fMRIPrep & giftbids Docker Images from internet (5+ minutes)
docker pull nipreps/fmriprep 
docker pull trends/gift-bids

mkdir outfMRIPrep # for fMRIPrep results
mv license.txt outfMRIPrep/. # needed for fMRIPrep
mkdir tmp # for fMRIPrep

#Run fmriprep (3h+). Normalizing ds005 subject to MNI space
docker run -ti --rm \
    -v ${TR_PWD}/ds005/:/data:ro \
    -v ${TR_PWD}/outfMRIPrep/:/out \
    -v ${TR_PWD}/tmp/:/work \
    nipreps/fmriprep \
    /data /out/fmriprep \
    participant --participant_label 01 --fs-license-file /out/license.txt \
    -w /work

mv smooth10.sh outfMRIPrep/.
chmod +x outfMRIPrep/smooth10.sh 

# Use fMRIPrep to smooth MNI fMRI with 10mm Gaussian kernel
docker run -ti --rm \
    -v ${TR_PWD}/ds005/:/data:ro \
    -v ${TR_PWD}/outfMRIPrep/:/out \
    -v ${TR_PWD}/tmp/:/work \
    --entrypoint /out/smooth10.sh nipreps/fmriprep

# Make fMRIPrep output BIDS compatible for GIFT
mkdir -p ds005-gift/sub-01/anat ds005-gift/sub-01/func
cp outfMRIPrep/fmriprep/dataset_description.json \
    ds005/task-mixedgamblestask_bold.json  ds005-gift/.
head -2 ds005/participants.tsv > ds005-gift/participants.tsv
cp outfMRIPrep/fmriprep/sub-01/anat/sub-01_space-MNI152NLin2009cAsym_desc-preproc_T1w.nii.gz \
    ds005-gift/sub-01/anat/sub-01_T1w.nii.gz
cp outfMRIPrep/fmriprep/sub-01/func/sub-01_task-mixedgamblestask_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold10sm.nii.gz \
    ds005-gift/sub-01/func/sub-01_task-mixedgamblestask_run-01_bold.nii.gz
mkdir ds005-gift-out

# Run GIFT BIDS-Apps
docker run -ti --rm \
    -v /tmp:/tmp \
    -v /var/tmp:/var/tmp \
    -v ${TR_PWD}/ds005-gift/:/data \
    -v ${TR_PWD}/ds005-gift-out/:/output \
    -v ${TR_PWD}/cfg/:/cfg \
    trends/gift-bids \
    /data /output participant --participant_label 01 \
    --config /cfg/config_spatial_ica_bids.m
