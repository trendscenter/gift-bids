#!/bin/bash

# TReNDs 112523
# Cyrus Eierud
# Helen Petropoulos 082024

# Prerequisits: FSL 7.4.1, Ubuntu 20.04

SUBJSESID=${1}
echo $SUBJSESID
SUBJID=$(echo $SUBJSESID | cut -d '_' -f 1 )
SESID=$(echo $SUBJSESID | cut -d '_' -f 2 )
DIR_BIDS_ROOT=${2}
DIR_BIDS_ROOT_GIFT=${2}"/derivatives/GIFT-BIDS/"

# Initiate all Input files from petsurfer & PetPrepMatlab
im4petFramesNii=`find ${DIR_BIDS_ROOT}"/derivatives/PETPrep/"${SUBJID} -name ${SUBJSESID}"*_space-mni305_pvc-nopvc_desc-preproc_pet.nii*"`
tsvPetTacs=`find ${DIR_BIDS_ROOT}"/derivatives/PETPrep/"${SUBJID} -name ${SUBJSESID}"*_pvc-nopvc_desc-mc_tacs.tsv"`
txtPetVoxSize=`find ${DIR_BIDS_ROOT}"/derivatives/PETPrep/sub-"${SUBJID}"/"${SUBJSESID} -name "gtm.stats.dat"`

# ls ${im4petFramesNii}
# ls ${tsvPetTacs}
# ls ${txtPetVoxSize}

# Read the petsurfer intensity data for 4 frames and cerebellar cortex
D_CER_L1=`awk -F '\t' 'NR == 2 {print $6}'  ${tsvPetTacs}`
D_CER_R1=`awk -F '\t' 'NR == 2 {print $20}'  ${tsvPetTacs}`

D_CER_L2=`awk -F '\t' 'NR == 3 {print $6}'  ${tsvPetTacs}`
D_CER_R2=`awk -F '\t' 'NR == 3 {print $20}'  ${tsvPetTacs}`

D_CER_L3=`awk -F '\t' 'NR == 4 {print $6}'  ${tsvPetTacs}`
D_CER_R3=`awk -F '\t' 'NR == 4 {print $20}'  ${tsvPetTacs}`

D_CER_L4=`awk -F '\t' 'NR == 5 {print $6}'  ${tsvPetTacs}`
D_CER_R4=`awk -F '\t' 'NR == 5 {print $20}'  ${tsvPetTacs}`

# Get average cerebellar intensities for the 4 frames
D_INTEN_CEREB_L=`echo "scale=9; (${D_CER_L1}+${D_CER_L2}+${D_CER_L3}+${D_CER_L4})/4" | bc`
D_INTEN_CEREB_R=`echo "scale=9; (${D_CER_R1}+${D_CER_R2}+${D_CER_R3}+${D_CER_R4})/4" | bc`

# echo $D_INTEN_CEREB_L
# echo $D_INTEN_CEREB_R

# Read the left and right cerebellar cortex sizes
D_CER_LVox=`cat ${txtPetVoxSize} | awk 'NR == 3 {print $5}'`
D_CER_RVox=`cat ${txtPetVoxSize} | awk 'NR == 17 {print $5}'`

# Calc voxelratio between left and right cerebellar cortex sizes
D_CEREB_RATIO=`echo "scale=9; ${D_CER_LVox}/(${D_CER_LVox}+${D_CER_RVox})" | bc`
# verbose: echo left vox && echo ${D_CER_LVox} && echo right vox && echo ${D_CER_RVox} && echo ratio && echo $D_CEREB_RATIO

# Calculate the denominator for mean image 
D_INTEN=`echo "scale=9; ${D_INTEN_CEREB_L}*${D_CEREB_RATIO}+${D_INTEN_CEREB_R}*(1-${D_CEREB_RATIO})" | bc`
# verbose: echo ${D_INTEN} && echo D_INTEN_CEREB_L && echo ${D_INTEN_CEREB_L} && echo D_INTEN_CEREB_R && echo ${D_INTEN_CEREB_R}

DIR_BIDS_ROOT_GIFT_PP=${DIR_BIDS_ROOT_GIFT}"preproc/"
mkdir -p ${DIR_BIDS_ROOT_GIFT_PP}"/"${SUBJID}"/"${SESID}

# Average the PET frames
fslmaths ${im4petFramesNii} -Tmean ${DIR_BIDS_ROOT_GIFT_PP}"/"${SUBJID}"/"${SESID}"/mni305TmeanTmp"

# Divide by inintensity and size ratio
fslmaths ${DIR_BIDS_ROOT_GIFT_PP}"/"${SUBJID}"/"${SESID}"/mni305TmeanTmp.nii" -div ${D_INTEN} ${DIR_BIDS_ROOT_GIFT_PP}"/"${SUBJID}"/"${SESID}"/"${SUBJSESID}"_space-mni305_desc-suvr+cerebcx+4gift_pet"

rm ${DIR_BIDS_ROOT_GIFT_PP}"/"${SUBJID}"/"${SESID}"/mni305TmeanTmp.nii.gz"
