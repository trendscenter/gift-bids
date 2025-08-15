% GICA BIDS App (tweaked from spm BIDS app file @ https://github.com/bids-apps/SPM/blob/master/spm_BIDS_App.m)

gica_inputs = evalin('base', 'gica_inputs');

%==========================================================================
%-BIDS App structure
%==========================================================================

BIDS_App = struct(...
    'dir','', ...            % BIDS root directory
    'outdir','', ...         % output directory
    'level','', ...          % first or second level analysis [participant*,group*]
    'participants',{{}}, ... % label of participants to be considered
    'config','',...          % configuration script
    'temp',true,...          % create local temporary copy of input files
    'validate',true);

%==========================================================================
%-Input arguments
%==========================================================================

if numel(gica_inputs) == 0, gica_inputs = {'--help'}; end
if numel(gica_inputs) == 1
    switch gica_inputs{1}
        case {'-v','--version'}
            disp('Group ICA Toolbox version: GroupICATv4.0c');
        case {'-h','--help'}
            fprintf([...
                'Usage: bids/gica BIDS_DIR OUTPUT_DIR LEVEL [OPTIONS]\n',...
                '       bids/gica [ -h | --help | -v | --version ]\n',...
                '\n',...
                'Mandatory gica_inputs:\n',...
                '    BIDS_DIR        Input directory following the BIDS standard\n',...
                '    OUTPUT_DIR      Output directory\n',...
                '    LEVEL           Level of the analysis that will be performed\n',...
                '                    {participant,group}\n',...
                '\n',...
                'Options:\n',...
                '    --participant_label PARTICIPANT_LABEL [PARTICIPANT_LABEL ...]\n',...
                '                    Label(s) of the participant(s) to analyse\n',...
                '    --session_label SESSION_LABEL [SESSION_LABEL ...]\n',...
                '                    Label(s) of the session(s) to analyse\n',...
                '    --config CONFIG_FILE\n',...
                '                    Optional configuration M-file describing\n',...
                '                    the analysis to be performed\n',...
                '    --skip-bids-validator\n',...
                '                    Skip BIDS validation\n',...
                '    -h, --help      Print usage\n',...
                '    -v, --version   Print version information and quit\n']);
        case {'--gui'}
            disp('Not implemented for this sprint');
            exit(0);
        otherwise
            fprintf([...
                'bids/gica: ''%s'' is not a valid syntax.\n',...
                'See ''bids/gica --help''.\n'],gica_inputs{1});
    end
    exit(0);
end

if numel(gica_inputs) < 2
    error('An output directory has to be specified.');
elseif numel(gica_inputs) < 3
    error('Missing argument participant/group.');
end

BIDS_App.dir    = gica_inputs{1};
BIDS_App.outdir = gica_inputs{2};
BIDS_App.level  = gica_inputs{3};

assignin('base', 'GICA_OUTPUTDIR', BIDS_App.outdir);

i = 4;
while i <= numel(gica_inputs)
    arg = gica_inputs{i};
    switch arg
        case '--participant_label'
            arg = 'participants';
        case '--session_label'
            arg = "session_label";
        case '--config'
            arg = 'config';
        case '--skip-bids-validator'
            BIDS_App.validate = false;
            i = i + 1;
            continue;
        otherwise
            warning('Unknown input argument "%s".',arg);
            arg = strtok(arg,'-');
    end
    j = 1;
    while true
        i = i + 1;
        if i <= numel(gica_inputs)
            if gica_inputs{i}(1) == '-', break; end
            BIDS_App.(arg){j} = gica_inputs{i};
            j = j + 1;
        else
            break;
        end
    end
end

%==========================================================================
%-Validation of input arguments
%==========================================================================

%- bids_dir
%--------------------------------------------------------------------------
if ~exist(BIDS_App.dir,'dir')
    error('BIDS directory "%s" does not exist.',BIDS_App.dir);
end

%- level [participant/group] & output_dir
%--------------------------------------------------------------------------
if strncmp('participant',BIDS_App.level,11)
    if ~exist(BIDS_App.outdir,'dir')
        sts = mkdir(BIDS_App.outdir);
        if ~sts
            error('BIDS output directory could not be created.');
        end
    end
elseif strncmp('group',BIDS_App.level,5)
    if ~exist(BIDS_App.outdir,'dir')
        error('BIDS output directory "%s" does not exist.',BIDS_App.outdir);
    end
else
    error('Unknown analysis level "%s".',BIDS_App.level);
end

%-Configuration file
%--------------------------------------------------------------------------
if ~isempty(BIDS_App.config)
    if numel(BIDS_App.config) > 1
        error('More than one configuration file provided.');
    end
    BIDS_App.config = char(BIDS_App.config);
    if isempty(fileparts(BIDS_App.config))
        BIDS_App.config = fullfile(fileparts(mfilename('fullpath')),BIDS_App.config);
    end
    if isempty(icatb_spm_file(BIDS_App.config,'ext'))
        BIDS_App.config = [BIDS_App.config '.m'];
    end
    if ~icatb_spm_existfile(BIDS_App.config)
        error('Cannot find configuration file "%s".',BIDS_App.config);
    end
else
    BIDS_App.config = fullfile(fileparts(mfilename('fullpath')),'config_spatial_ica_bids.m');
    if ~icatb_spm_existfile(BIDS_App.config)
        error('No default configuration file found for "%s" level.',BIDS_App.level);
    end
end

%==========================================================================
%-Parse BIDS directory and validate list of participants
%==========================================================================

%-Call BIDS Validator
%--------------------------------------------------------------------------
if BIDS_App.validate
    [status, result] = system('bids-validator --version');
    if ~status
        [status, result] = system(['bids-validator "' BIDS_App.dir '"']);
        if status~=0
            fprintf('%s\n',result);
            exit(1);
        end
    end
end

%-Parse BIDS directory
%--------------------------------------------------------------------------
BIDS = icatb_spm_BIDS(BIDS_App.dir);

%- --participant_label
%--------------------------------------------------------------------------
% Remove sub- label before BIDS search
BIDS_App.participants = strrep(BIDS_App.participants, 'sub-', '');
if isempty(BIDS_App.participants)
    BIDS_App.participants = icatb_spm_BIDS(BIDS,'subjects');
else
    df = setdiff(BIDS_App.participants, icatb_spm_BIDS(BIDS,'subjects'));
    if ~isempty(df)
        error('Participant directory "%s" does not exist.',df{1});
    end
end
% Return sub- label after BIDS search
BIDS_App.participants = strcat('sub-', BIDS_App.participants);


%% pass inputs to gift
inputData = icatb_eval_script(BIDS_App.config);
inputData.outputDir = BIDS_App.outdir;
bids_info.root_dir = BIDS_App.dir;
bids_info.subjects = BIDS_App.participants; % Cell string of subject ids or leave empty to select all
try
    need_pref = ~startsWith(BIDS_App.session_label, 'ses-');
    BIDS_App.session_label(need_pref) = strcat('ses-', BIDS_App.session_label(need_pref));
    bids_info.sessions = BIDS_App.session_label; %Support for sessions
catch
    %Give a warning about sessions if sessions are found in BIDS structure
    %and not set up in input
    for i=1:length(BIDS.subjects)
        if contains(lower(BIDS.subjects(i).session),'ses')
            disp(['gift-bidsWarning ' char(datetime) '. gica_bids_app.m: Sessions found in BIDS folder, but not set up sessions using --participant_label']);
            break;
        end
    end
end
inputData.bids_info = bids_info;
inputData.inputFile = BIDS_App.config;

%% Generate param file
param_file = icatb_read_batch_file(inputData);
load(param_file);

%% Run Analysis
sesInfo = icatb_runAnalysis(sesInfo, 1);

if (isfield(sesInfo.userInput, 'display_results') && ~strcmpi(sesInfo.modality, 'eeg'))
    %results.formatName = display_results;
    icatb_report_generator(param_file, sesInfo.userInput.display_results);
end

% Close all windows
close all force
