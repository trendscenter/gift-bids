# PET Preprocessing for GIFT BIDS-App
### Pipeline before GIFT ICA using PetSurfer and PETPrepMATLAB
![TReNDS](https://trendscenter.org/wp-content/uploads/2019/06/background_eeg_1.jpg)
### Short Description of PET to GIFT Pipeline
This pipeline assumes PET data (a raw PET image and an anatomical T1 MRI in BIDS format). It will then use PetSurfer, PETPrepMATLAB and a small BASH script to normalize PET images for GIFT independent component analysis processing. This pipeline assumes the PET data is collected in 4 frames per subject. Check the next section for more details.
### PET to GIFT Pipeline
The following is an ouline of the different steps used to process PET for GIFT.
1. Example of data selection. This example was first run after selecting an ADNI dataset for control subjects, having florbetapir (FBP) PET tracer collected in 4 frames, all four being 5 minutes long. Since 3T MRI T1 images are abundant in the ADNI dataset, all subjects with FBP images, the 3T T1 MRI, closest in time, were selected to pair the subject's FBP image. 
2. Formatted ADNI data into BIDS format according with following:
    1. /myfiles/bidsRoot
        1. participants.tsv
        2. participants.json
        3.	other files
        4.	derivatives
            1. freesurfer

3. 
4. [GIFT BIDS-Apps](#secBids)
5. [Screen Shots](#secScreen)
6. [Toolboxes](#secTools)
	1. [Mancovan](#secToolMan)
