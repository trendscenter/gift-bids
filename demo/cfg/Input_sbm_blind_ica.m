%% Batch script to run blind ICA on SBM (or PET)
% Enter the values for the variables required for the ICA analysis.
% Variables are on the left and the values are on the right.
% Characters must be enterd in single quotes
%
% After entering the parameters, use icatb_batch_file_run(inputFile); 
% Or include as a config file for Docker

%% Type of Reliability analysis
% Options are 1 and 2.
% 1 - Regular Group ICA
% 2 - Group ICA using icasso
which_analysis = 2;

%% ICASSO options. %DIFF
% This variable will be used only when which_analysis variable is set to 2.
icasso_opts.sel_mode = 'randinit';  % Options are 'randinit', 'bootstrap' and 'both'
icasso_opts.num_ica_runs = 20; % Number of times ICA will be run
icaOptions{1,1} = 'posact';
icaOptions{1,2} = 'on';

%% Data Pre-processing options
% 1 - Remove mean per time point
% 2 - Remove mean per voxel
% 3 - Intensity normalization
% 4 - Variance normalization
preproc_type = 1;

%% File input params
dataSelectionMethod = 4;
% Input file patterns (assuming multiple subjects stacked into a 4D file)
input_data_file_patterns = {'/data/sub-01/pet/sub-01_task-rest_pet.nii' ;
};

%% Output files prefix
prefix = 'blind';

%% modalityType may be fMRI, EEG, and sMRI
modalityType = 'sMRI';

%% Dummy scans
dummy_scans = 0;

%% Input mask
maskFile = 'default&icv';

%% PCA Type. Also see options associated with the selected pca option.
% PCA options and SVD PCA are commented.
% Options are 1, 2, 3, 4 and 5.
% 1 - Standard 
% 2 - Expectation Maximization
% 3 - SVD
% 4 - MPOWIT
% 5 - STP
pcaType = 4;

% 1 means infomax, 2 means fastICA, etc.
algoType = 1;

%% Pre-processing type
preproc_type = 1;

%% Number of pc to reduce each subject down to at each reduction step
% The number of independent components the will be extracted is the same as 
% the number of principal components after the final data reduction step.  
numOfPC1 = 40;

%% Scale the resulting components. Options are 0, 1, 2
% 0 - Don't scale
% 1 - Scale to Percent signal change
% 2 - Scale to Z scores
scaleType = 0;

%% Report generator 
display_results = 0;

%% Back-reconstruction type
backReconType = 4;

%% Output directory
outputDir = '/output';

%%  MDL Batch Estimation. If 1 is specified then estimation of 
% the components takes place and the corresponding PC numbers are associated
% Options are 1 or 0
doEstimation = 0; 

%% Performance type options
% 1 - Maximize Performance
% 2 - Less Memory Usage
% 3 - User Specified Settings
perfType = 1

%% Parallel info %DIFF
% enter mode serial or parallel. If parallel, enter number of
% sessions/workers to do job in parallel
parallel_info.mode = 'serial';
% parallel_info.num_workers = 40;



