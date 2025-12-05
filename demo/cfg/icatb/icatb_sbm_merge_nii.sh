#!/bin/bash

# converts 3d nii files into a single 4d nii file
# Cyrus Eierud, TReNDS 112025 


DIR_PREV=$(pwd)
mkdir /out/tmp_dir
find /out/input_sbm -iname "*.nii" -exec mv {} /out/tmp_dir/. \;
find /out/input_sbm -iname "*.nii.gz" -exec mv {} /out/tmp_dir/. \;
cd /out/tmp_dir
ls *.nii* > /out/subject_file_name_order_read_in.txt
fslmerge -t /out/input_sbm/multisubject_sbm.nii.gz  *.nii*
cd /out/input_sbm
gzip multisubject_sbm.nii.gz -d
rm -rf /out/tmp_dir
cd "$DIR_PREV"
