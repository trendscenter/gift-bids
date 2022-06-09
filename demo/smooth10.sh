#!/bin/bash

# Smoothes fMRIPrep results with 10mm gaussian kernel
# Cyrus Eierud, TReNDS 050522

fslmaths /out/fmriprep/sub-01/func/sub-01_task-mixedgamblestask_run-*1_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz \
  -kernel gauss 4.2466452 \
  -fmean /out/fmriprep/sub-01/func/sub-01_task-mixedgamblestask_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold10sm.nii.gz
