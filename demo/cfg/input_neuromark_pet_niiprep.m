%% Batch script to run Constrained NeuroMark ICA on SBM (or PET) 
% using external template
% Enter the values for the variables required for the ICA analysis.
% Variables are on the left and the values are on the right.
% Characters must be enterd in single quotes
%
% After entering the parameters, use icatb_batch_file_run(inputFile); 
% Or include (together withthe external template) as a config file for Docker (e.g., Neuromark_PET-FBP_1.0_modelorder-40_2x2x2.nii)

%% Output directory
outputDir = '/out';

input_4d = [outputDir filesep 'input_sbm'];

outputNii = fullfile(input_4d, 'multisubject_sbm.nii');

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


%% Output files prefix
prefix = 'GIGICA';

dataSelectionMethod = 4;

%% modalityType may be fMRI, EEG, and sMRI 
modalityType = 'sMRI';

%% Input file patterns 
input_data_file_patterns = outputNii;

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
% parallel_info.num_workers = 4;


% Save current directory
DIR_PREV = pwd;

% Define paths
% outputDir = '/out'; % may be set above
tmpDir = [outputDir filesep 'tmp_dir'];
inputDir = '/data';
subjectListFile = [input_4d filesep 'subject_file_name_order_read_in.txt'];

% Create temporary directory
if ~exist(tmpDir, 'dir')
    mkdir(tmpDir);
end

% Create 4d input directory
if ~exist(input_4d, 'dir')
    mkdir(input_4d);
end

% Find all .nii and .nii.gz files recursively under /out/input_sbm
filesNii   = dir(fullfile(inputDir, '**', '*.nii'));
filesNiiGz = dir(fullfile(inputDir, '**', '*.nii.gz'));
allFiles = [filesNii; filesNiiGz];

% Move all found files into tmpDir
for k = 1:numel(allFiles)
    src = fullfile(allFiles(k).folder, allFiles(k).name);
    dst = fullfile(tmpDir, allFiles(k).name);

    % Avoid moving file onto itself if already in tmpDir
    if ~strcmp(src, dst)
        copyfile(src, dst);
    end
end

% Change to tmp directory
cd(tmpDir);

% Get list of *.nii* files in tmpDir
tmpFiles = dir(fullfile(tmpDir, '*.nii*'));
fileNames = {tmpFiles.name};

% Write filenames to subject_file_name_order_read_in.txt
fid = fopen(subjectListFile, 'w');
if fid == -1
    error('Could not open file for writing: %s', subjectListFile);
end
for k = 1:numel(fileNames)
    fprintf(fid, '%s\n', fileNames{k});
end
fclose(fid);

% Check that files exist
if isempty(fileNames)
    error('No .nii or .nii.gz files found in %s', tmpDir);
end

% Build full paths
fileList = fullfile(tmpDir, fileNames);

% Read first volume as reference
nFiles = numel(fileList);
Vref = icatb_spm_vol(fileList{1});
if numel(Vref) ~= 1
    error('First input file must be a 3D image, not a 4D image: %s', fileList{1});
end

Y4D = [];

% Read all images and stack into 4D array
for i = 1:nFiles
    Vi = icatb_spm_vol(fileList{i});
    if numel(Vi) ~= 1
        error('Input file must be 3D, not 4D: %s', fileList{i});
    end

    Yi = icatb_spm_read_vols(Vi);

    % Optional safety checks
    if ~isequal(Vi.dim(1:3), Vref.dim(1:3))
        error('Dimension mismatch for file: %s', fileList{i});
    end

    if max(abs(Vi.mat(:) - Vref.mat(:))) > 1e-6
        error('Orientation/affine mismatch for file: %s', fileList{i});
    end

    if i == 1
        Y4D = zeros([size(Yi), nFiles], class(Yi));
    end

    Y4D(:,:,:,i) = Yi;
end

% Prepare 4D output header
Vout = repmat(Vref, nFiles, 1);
for i = 1:nFiles
    Vout(i).fname = outputNii;
    Vout(i).n = [i 1];
end

% Create and write 4D file
Vout = icatb_spm_create_vol(Vout);
for i = 1:nFiles
    icatb_spm_write_vol(Vout(i), Y4D(:,:,:,i));
end

% Remove temporary directory
cd(inputDir);
if exist(tmpDir, 'dir')
    rmdir(tmpDir, 's');
end

% Return to previous directory
cd(DIR_PREV);
