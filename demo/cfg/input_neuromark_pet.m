%% Batch script to run Constrained NeuroMark ICA on PET (or SBM) 
% using external template
% Enter the values for the variables required for the ICA analysis.
% Variables are on the left and the values are on the right.
% Characters must be enterd in single quotes
%
% After entering the parameters, use icatb_batch_file_run(inputFile); 
% Or include (together withthe external template) as a config file for Docker (e.g., Neuromark_PET-FBP_1.0_modelorder-40_2x2x2.nii)

%% Data Pre-processing options
% 1 - Remove mean per time point
% 2 - Remove mean per voxel
% 3 - Intensity normalization
% 4 - Variance normalization
preproc_type = 1;
%preproc_type = 'none';

%% Performance type
perfType = 1;

%% Reliability analysis
which_analysis = 1;
%% ICASSO options. %DIFF
% This variable will be used only when which_analysis variable is set to 2.
icasso_opts.sel_mode = 'randinit';  % Options are 'randinit', 'bootstrap' and 'both'
icasso_opts.num_ica_runs = 20; % Number of times ICA will be run
icaOptions{1,1} = 'posact';
icaOptions{1,2} = 'on';

%% Output directory
outputDir = '/output';

%% Output files prefix
prefix = 'GIGICA';

dataSelectionMethod = 4;

%% modalityType may be fMRI, EEG, and sMRI 
modalityType = 'sMRI';

%% Input file patterns 
input_data_file_patterns = {'/out/input_sbm/multisubject_sbm.nii' ;};

%% Dummy scans
dummy_scans = 0;

%% Input mask
maskFile = 'default&icv';

%% PCA Algorithm
pcaType = 'Standard';

%% ICA Algorithm (15 = MOO-ICAR for SBM)
algoType = 15;

%% Back-reconstruction type
backReconType = 4;

%% Pre-processing type
preproc_type = 1;

%% MDL Estimation 
doEstimation = 0;

%% Number of data reduction steps
numReductionSteps = 2;

%% Number of PC in the first PCA step
numOfPC1 = 63;

%% Number of PC in the second PCA step
numOfPC2 = 53;

%% Scale the Results. Options are 0, 1, 2
% 0 - Don't scale
% 1 - Scale to Percent signal change
% 2 - Scale to Z scores
scaleType = 0;

%% Spatial references 
%refFiles = which('Neuromark_fMRI_1.0.nii');
refFiles = '/cfg/icatb/Neuromark_PET-FBP_1.0_modelorder-40_2x2x2.nii';

%% Report generator 
display_results = 1;

%% Parallel info %DIFF
% enter mode serial or parallel. If parallel, enter number of
% sessions/workers to do job in parallel
parallel_info.mode = 'serial';
% parallel_info.num_workers = 40;
