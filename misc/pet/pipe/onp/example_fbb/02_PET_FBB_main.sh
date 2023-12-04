#!/bin/bash

# TReNDS Nov 2023
# Main script to convert ADNI DICOM to BIDS 
#   format before GIFT processing

# Downloaded FBB pet from ADNI were according 
#   with subject ID in 
#   04_ADNI_Downloaded_DCM_FBB.txt file
#   to /root/data_fbb/ADNI_FBB directory

# Downloaded T1 from ADNI were according 
#   with image ID in 
#   34_ADNI_Downloaded_DCM_T1.txt file
#   to /root/data_fbb/ADNI_T1 directory

cd /root/data_fbb/ADNI_FBB
./05_05_PET_dcm2niix.sh #Convert to DICOM
./08_mkdir_bids.sh
./10_mv_nii.sh
./15_rename_nii.sh
./20_mv_json.sh
./25_rename_json.sh
cd /root/data_fbb/ADNI_T1
./35_t1_dcm2niix.sh
./40_mv_nii_t1.sh
./45_mv_json_t1.sh

# After this the files are ready for SLURM jobs

# FreeSurfer SLURM: 70_slurm_PET_FBB_FS_Nov2023.sh

# PET Motion correction SLURM: 80_slurm_PET_FBB_HMC_Nov2023.sh

# PETPrepMATLAB SLURM: 90_slurm_PETPrep_FBB_Nov2023.sh

# After the SLURM jobs you can finalise processing 
#   using ./99_final_intensities.sh




