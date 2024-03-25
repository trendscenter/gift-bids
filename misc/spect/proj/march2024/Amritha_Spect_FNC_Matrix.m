%% set up main variables for analyses  
a = spm_read_vols(spm_vol('SPECT_output_group_loading_coeff_.nii'));

size(a); %tells you the dimensions of a, in this case it's a subject ...
         % by component matrix of 213 x 53

%you can save it as a txt file as follows:
save("loadings.txt","a","-ascii")

 %we can compare group differences in two ways, one testing for differences
 %in the loading parameters, that is the degree to which each group
 %'expresses' a given component relative to another.

 %set up indices for healthy control and patients (here assuming you
 %selected the controls first, if not you'll want to tweak it)
 hcind = 1:76;
 szind = 77:213;

 %compute mean of hc and sz for the 53 components
 hcmn = mean(a(hcind,:));  
 save("hcmean.txt", "hcmn", "-ascii")
 szmn = mean(a(szind,:));  
 save("szmean.txt", "szmn", "-ascii")
 %save as txt files for R analysis


 %two sample t-test to compare HC vs SZ
 [h,p,ci,stats]=ttest2(a(hcind,:),a(szind,:));
  save("pvals_uncorrected.txt","p","-ascii") % save p values into text file

 %take a look at the component with the largest t-value
 %the other way to compare is to look at the structural network
 %connectivity or SNC, the cross-correlation among ICA loading parameters.
 
%% all four main plots in one plot 

 %full data
 subplot(2,2,1)
 imagesc(corr(a),[-1 1]); colormap jet; axis image;
 title('full data')

 %controls
 subplot(2,2,2)
 imagesc(corr(a(hcind,:)),[-1 1]); colormap jet; axis image;
 title('controls')

 %schizophrenia
 subplot(2,2,3)
 imagesc(corr(a(szind,:)),[-1 1]); colormap jet; axis image;
 title('schizophrenia');

 %controls - schizophrenia
 subplot(2,2,4)
 imagesc(corr(a(hcind,:))-corr(a(szind,:)),[-.5 .5]); colormap jet; axis image;
 title('controls-schizophrenia')

%% display FNC plots 

  %display scz FNC only
  display_FNC(corr(a(szind,:)),.4)
  title ('SZ FNC map')

  %display controls FNC only
  display_FNC(corr(a(hcind,:)),.4)
  title ('controls FNC map')

  %plot FNC matrix controls - scz
  display_FNC(corr(a(hcind,:))-corr(a(szind,:)));
  title ('53x53 FNC plot of healthy-scz differences')
  
  %display just the lower half of triangle
  display_FNC(tril((corr(a(hcind,:))-corr(a(szind,:)))));
  title('Lower Half of 53x53 FNC plot')

  %% do FDR correction and plot subsequent q vals

  N = 213; %number of subjects
  fnc = vec; %rename vector to fnc variable
  pvals = 2*(1-tcdf(r_to_t(satlin(abs(fnc)),N-1),N-1)); %get pvalues  
  save("pvals_uncorrected.txt","pvals","-ascii")
  
  %do fdr and bonferonni correction to compare results
  qvals = mafdr(pvals, 'BHFDR', true);  %fdr correction - obtain q values
  save("qvals_corrected.txt","qvals","-ascii")

%% now make variables and q vals for patients only

  N = 137; %number of subjects for patients
  fnc_patients = vec_patients; %rename vector to fnc variable
  pvals_patients = 2*(1-tcdf(r_to_t(satlin(abs(fnc_patients)),N-1),N-1)); %get pvalues
  save("pvals_uncorrected_patients.txt","pvals_patients","-ascii")
  
  %do fdr and bonferonni correction to compare results
  qvals_patients = mafdr(pvals_patients, 'BHFDR', true);  %fdr correction - obtain q values
  save("qvals_corrected_patients.txt","qvals_patients","-ascii")

 %% create variables to see relationships between FNC and clinical variables
 %transpose indices so that plots can be rendered, rename variables

 hcind_transp = hcind'; %transpose hc indices variable
 szind_transp = szind'; %transpose sz indices variable
 hcmn_transp = hcmn'; %transpose hc mean variable
 szmn_transp = szmn'; %transpose sz mean variable

%% %% hc - sz connectogram general with the 21 components uncorrected
%Nifti file name
fname = 'SPECT_output_group_component_ica_.nii'; %your component maps

%Network names and components relative to the component nifti file entered above in variable fname                 
C = corr(a(hcind,:))-corr(a(szind,:)); %hc-sz differences 
comp_network_names = {'SC Network', 4; % SC Network
   'AUD Network', 6;   % AUD network
   'SM Network', [8,16]; % Sensorimotor comps
   'VIS Network', [18 19 20, 23, 25]; % Visual comps
   'CC Network', [27, 29, 30, 31, 32, 34, 38, 40, 41]; % CC Network
   'DMN Network', [44,47]; %DMN Network
   'CB Network', 52}; % CB Network
     
%Slice view

icatb_plot_connectogram([], comp_network_names, 'C', C, 'threshold', 2 , 'conn_threshold', 0.19 , 'image_file_names', fname, 'colorbar_label', 'Corr', 'display_type', 'render', 'convert_to_zscores', 'no', 'slice_plane', 'sagittal', 'exclude zeroes', 0);
 
%% do connectogram for fdr corrected p vals for healthy-patients which survived FDR correction
%15 components 
%Nifti file name
fname = 'SPECT_output_group_component_ica_.nii'; %your component maps

C = corr(a(hcind,:))-corr(a(szind,:)); %hc-sz differences 
C = C.*(icatb_vec2mat(qvals<=0.05)); %this zeros out Css that are greater than 0.05

%Network names and components relative to the component nifti file entered above in variable fname
comp_network_names = {'SC Network', 4; % SC Network
   'AUD Network', 6;   % AUD network
   'SM Network', 16; % Sensorimotor comps
   'VIS Network', [18,19,23]; % Visual comps
   'CC Network', [29,30,31,32,34,38,40,41]; % CC Network
   'DMN Network', 47}; % DMN Network    
     
%Slice view
%threshold picked after comparing q values to correlations corresponding to a q = 0.05

icatb_plot_connectogram([], comp_network_names, 'C', C, 'threshold', 2 , 'conn_threshold', 0.1, 'image_file_names', fname, 'colorbar_label', 'Corr', 'display_type', 'render', 'convert_to_zscores', 'no', 'slice_plane', 'sagittal', 'exclude zeroes', 0);
 
%% connectogram for patient regressions with 11 components - [Table 2 Results]
fname = 'SPECT_output_group_component_ica_.nii'; %your component maps

%Network names and components relative to the component nifti file entered above in variable fname
C = corr(a(szind,:)); %new FDR corrected matrix for patients
C = C.*(icatb_vec2mat(qvals_patients<=0.05)); %this zeros out Css that are greater than 0.05

comp_network_names = {'SM Network', 14; % Sensorimotor comps
   'CC Network', [26, 30, 31, 35, 36, 38, 40]; % CC Network
   'DMN Network',[43, 44, 48]}; % DMN Network
 
%Slice view

icatb_plot_connectogram([], comp_network_names, 'C', C, 'threshold', 2, 'conn_threshold', 0.4 , 'image_file_names', fname, 'colorbar_label', 'Corr', 'display_type', 'render', 'convert_to_zscores', 'no', 'slice_plane', 'sagittal', 'exclude zeroes', 0);

%% make connectograms for clinical variables - regression results [Table 3 Results]
%5 components 
%Nifti file name
fname = 'SPECT_output_group_component_ica_.nii'; %your component maps
 
C = corr(a(szind,:));   %SZ patient FNC
C = C.*(icatb_vec2mat(qvals_patients<=0.05)); %this zeros out Css that are greater than 0.05

%Network names and components relative to the component nifti file entered above in variable fname
comp_network_names = {
    'CC Network', [30, 31, 38, 40]; % CC Network
    'DMN Network', 44}; % DMN Network
%Slice view

icatb_plot_connectogram([], comp_network_names, 'C', C, 'threshold', 2, 'conn_threshold', 0.3, 'image_file_names', fname, 'colorbar_label', 'Corr', 'display_type', 'render', 'convert_to_zscores', 'no', 'slice_plane', 'sagittal', 'exclude zeroes', 0);
%% get spatial maps for 19 components and 2 components for healthy-patients results
%Use this command to get the spatial maps for all significant scz and
 %healthy control components (19 for HC > SZ and 2 components for SZ > HC respectively), modify as
 %needed 

    files = {'SPECT_output_group_component_ica_.nii,4',... 
    'SPECT_output_group_component_ica_.nii,6',...
    'SPECT_output_group_component_ica_.nii,8',...
    'SPECT_output_group_component_ica_.nii,16',... 
    'SPECT_output_group_component_ica_.nii,18',... 
    'SPECT_output_group_component_ica_.nii,19',...
    'SPECT_output_group_component_ica_.nii,20',...
    'SPECT_output_group_component_ica_.nii,23',...
    'SPECT_output_group_component_ica_.nii,25',...
    'SPECT_output_group_component_ica_.nii,27',...
    'SPECT_output_group_component_ica_.nii,29',...
    'SPECT_output_group_component_ica_.nii,30',...
    'SPECT_output_group_component_ica_.nii,31',...
    'SPECT_output_group_component_ica_.nii,32',...
    'SPECT_output_group_component_ica_.nii,34',...
    'SPECT_output_group_component_ica_.nii,38',...
    'SPECT_output_group_component_ica_.nii,40',...
    'SPECT_output_group_component_ica_.nii,41',...
    'SPECT_output_group_component_ica_.nii,47'};
icatb_image_viewer(files,'display_type','montage','structfile',fullfile(fileparts(which('gift.m')),'icatb_templates','ch2bet.nii'), ...
    'threshold', 1.0, 'slices_in_mm', (-60:8:60), 'convert_to_zscores', 'yes', 'image_values', 'positive','iscomposite','yes');


%%do same now for the 2 components

%Use this command to get the spatial maps for all significant scz and
 %healthy control components (19 for HC > SZ and 2 components for SZ > HC respectively), modify as
 %needed 

    files = {'SPECT_output_group_component_ica_.nii,44',...
    'SPECT_output_group_component_ica_.nii,52'};
icatb_image_viewer(files,'display_type','montage','structfile',fullfile(fileparts(which('gift.m')),'icatb_templates','ch2bet.nii'), ...
    'threshold', 1.0, 'slices_in_mm', (-60:8:60), 'convert_to_zscores', 'yes', 'image_values', 'positive','iscomposite','yes');
    
%reminders - the -70:5:40 slice parameter indicates less images, whereas if
%I removed the - sign in the front, you add more slices
%for the latest images, I used the following slice parameters: [-70:8:60]
%I modified this to also be [-60:8:60]

%% get spatial maps associated with clinical variables 
%components for significant results for hearing voices, age and sex
%first start with sex

    files = {'SPECT_output_group_component_ica_.nii,14'};
icatb_image_viewer(files,'display_type','montage','structfile',fullfile(fileparts(which('gift.m')),'icatb_templates','ch2bet.nii'), ...
    'threshold', 1.0, 'slices_in_mm', (-60:8:60), 'convert_to_zscores', 'yes', 'image_values', 'positive','iscomposite','yes');

%now hearing voices

    files = {'SPECT_output_group_component_ica_.nii,26',... 
    'SPECT_output_group_component_ica_.nii,30',...
    'SPECT_output_group_component_ica_.nii,31',...
    'SPECT_output_group_component_ica_.nii,35',... 
    'SPECT_output_group_component_ica_.nii,36',... 
    'SPECT_output_group_component_ica_.nii,38',...
    'SPECT_output_group_component_ica_.nii,40'};
icatb_image_viewer(files,'display_type','montage','structfile',fullfile(fileparts(which('gift.m')),'icatb_templates','ch2bet.nii'), ...
    'threshold', 1.0, 'slices_in_mm', (-60:8:60), 'convert_to_zscores', 'yes', 'image_values', 'positive','iscomposite','yes');

%now age

 files = {'SPECT_output_group_component_ica_.nii,43',...
    'SPECT_output_group_component_ica_.nii,44',...
    'SPECT_output_group_component_ica_.nii,48'};

 icatb_image_viewer(files,'display_type','montage','structfile',fullfile(fileparts(which('gift.m')),'icatb_templates','ch2bet.nii'), ...
    'threshold', 1.0, 'slices_in_mm', (-60:8:60), 'convert_to_zscores', 'yes', 'image_values', 'positive','iscomposite','yes');

