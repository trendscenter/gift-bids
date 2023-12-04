# PET Preprocessing for GIFT BIDS-App, Basic Script examples
![TReNDS](https://trendscenter.org/wp-content/uploads/2019/06/background_eeg_1.jpg)
### Example how to convert ADNI FlorBetaBen data to GIFT input
This pipeline assumes that you download files to your /root/data_fbb/ADNI_FBB and /root/data_fbb/ADNI_T1 directories. Then using the scripts in this folder you may complete the entire preprocessing steps before GIFT ICA processing.
After you place the scripts in correct directories you may run the first 8 scripts, using the 02_PET_FBB_main.sh script. After that you need to run 3 SLURM jobs (70_slurm_PET_FBB_FS_Nov2023.sh, 80_slurm_PET_FBB_HMC_Nov2023.sh, 90_slurm_PETPrep_FBB_Nov2023.sh) in arrays. Finally you run 99_final_intensities.sh.
