function Undersampling_Step_size(config_file)
%% Undersampling_Step_size - tests if the spatial resolution is high enough
% Rellie M. Goddard, July 2020

% This function examines how the effective step-size of EBSD maps affects
% the mean line intercept length of a given phase in the map.

%% Required functions:
% * ProcessEBSD_fun.m
% * LinearIntercepts_fun.m
% * Undersampling.fun.m

%% Required user inputs:
% * nx: The number of intercept lines, chosen based on analysis from
%       No_intercepts_check.m.
% * Int_max: The number of times you want to increase the step-size. The
%       step-size at an iteration will be Int_max multiplied by the original
%       step-size. For each iteration a .ctf file will be created.
% * Image_title: Title for figure
% * Header_size: Number of lines, up to and including the line starting with
%       "phase" in the .ctf file (as seen if opened in a text editor)
% * gb_min: Minimum misorientation angle to define a grain boundary in
%       degrees. Used for constructing maps
% * sg_min: Minimum misorientation angle to define a subgrain boundary in
%       degrees. Only used for constructing maps.
% * cutoff: Minimum misorientation angle to define a subgrain boundary in
%       degrees. Used for piezometer calculations. Recommended value is 1.
% * phase: Name of the phase of interest (e.g., 'Forsterite')
% * crystal: Crystal system of the phase to be examined (e.g., 'orthorhombic')
% * test: When set to 1, reduces the size of the input EBSD map by taking
%       every tenth pixel in both the horizontal and vertical direction. Can be
%       utilized to ensure the script runs correctly for a new sample file or for
%       troubleshooting. During full analysis, test should be set to 0.
% * Phase_map: To output a phase map, set to 1. Othewise, set to 0.
% * Band_contrast: To output a band contrast map, set to 1. Otherwise, set
%       to 0.
%
%% Additional user inputs produced by MTEX
% * CS: Crystal symmetry class variable for all indexed phaes in EBSD map.
% * pname: Path to data (e.g., 'C:/Users/admin/data/')
% * fname: File name combined with path
%
%% Results
% A figure showing the Intercept Variation Factor plotted against the number
% of pixels per intercept will be produced. See Goddard et al., (submitted) for an
% explanation of the variables.
%
% The test is considered successful if the measured mean intercept length
% is not sensitive to the effective step size. The presence of an asymptote
% at an intercept variation factor of 1 is evidence that step size is small
% enough to capture the mean intercept length. If such an asymptote doesn't
% exist then either re-map the sample, using a smaller step size, or use the
% subgrain-size stress measurement as a lower bound.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data import
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[par] = readconfigfile(config_file);

%% USER INPUT: Data import information from MTEX
% This information is produced automatically by the MTEX import wizard
% Paste in your CS, plotting conventions, pname, and fname here.

% Specify Crystal and Specimen Symmetries
% crystal symmetry
CS =  par.CS;
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% Specify File Names
fname = par.fname;

cd(par.pname)
%% USER INPUT: Required information (taken from config)
nx = par.nx; % Number of intercept lines
Int_max = par.Int_max; % Number of times to increase the step-size
title_text = par.title_text; % Title for figures
header_size = par.header_size; % Number of rows in header of CTF
gb_min = par.gb_min; % Minimum misorientation for grain boundary (for figures)
sg_min = par.sg_min; % Minimum misorientation for subgrain boundary (for figures)
cutoff = par.cutoff; % Minimum misorientation for subgrain boundary (for calculation)
phase = par.phase; % Phase to measure. Must match a phase present in CS.
crystal = par.crystal; % Crystal system of phase to measure.
Phase_map = par.Phase_map; % Set to 1 to plot a phase map of the EBSD data.
Band_contrast = par.Band_contrast; % Set to 1 to plot a band contrast map.
test = par.test; % Set to 1 to speed up analysis when troubleshooting.
plot_its = par.plt_its; % set the iteration numbers that you would like to plot (0-9). Keep empty to plot none, set to 10 for all
dev = par.dev; % Set to 1 to use development codes
voronoi = par.voronoi; % Use vornonoi decomposition
%% END OF USER INPUTS

%% Programmatically calculate other necessary variables
temp = split(fname, {filesep,'.'});
sampname = temp{end-1}; % Extract file name with no extension
ny = nx; % Set number of intercepts in y-direction to equal number of intercepts in the x-direction.

%% Calculate and plot
[fname_new, stepx_all, Step_size_SG_size] = undersampling_fun(Int_max, sampname, header_size,gb_min,sg_min,test, Phase_map, Band_contrast, nx, ny, cutoff, phase, crystal, CS, plot_its, dev, voronoi);

%close all

figure
plot(Step_size_SG_size(1)./stepx_all, Step_size_SG_size/Step_size_SG_size(1),'-o', 'LineWidth', 3, 'color', [0.49 0.34 0.75], 'MarkerSize', 7);
set(0,'DefaultAxesFontSize',15,'DefaultAxesFontName','helvetica','DefaultAxesTickLength',[.03 .02],'DefaultAxesLineWidth',2);
set(gca,'fontsize',15);
ylabel('Intercept variation factor ,\bf\lambda\rm/\bf\lambda\rm_b_e_s_t', 'FontSize',15);
xlabel('Pixels per intercept, \bf\lambda\rm_b_e_s_t/step size', 'FontSize', 15);
title(title_text, 'FontSize', 15)

end
