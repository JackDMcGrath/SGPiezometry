%% Undersampling_Step_size - tests if the spatial resolution is high enough 
% Rellie Goddard, July 2020

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
%       step-size. 
% * dirname: Path to data (e.g., 'C:/Users/admin/data')
% * sample_name: File name with no extension (e.g., 
% * title: Title for figure 
% * Header_size: Number of lines, up to and including the line starting with
%       "phase" in the .ctf file (as seen if opened in a text editor)
% * gb_min: Grain size, used for constructing maps.
% * sg_min: Subgrain size, used for constructing maps
% * cutoff: Minimum misorientation angle used to define a subgrain boundary.
%       If using recommended Goddard subgrain-size piezometer parameters,
%       set to 1.
% * phase: Name of the phase of interest (e.g., 'olivine')
% * crystal: Crystal system of the phase to be examined (e.g., 'orthorhombic')
% * Phase_map: To output a phase map, set to 1. Othewise, set to 0.
% * Band_contrast: To output a band contrast map, set to 1. Otherwise, set
%       to 0.
%
%% Results
% A figure showing the Intercept Variation Factor plotted against the number 
% of pixels per intercept will be produced. See Goddard et al., 2020 for an
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
clear, close all 

%USER INPUT: Number of intercepts
nx = [];
ny = nx;

%USER INPUT: Maximum times of reducing the step-size 
Int_max = []; 

%File Location 
dirname = 'yourPath';

% USER INPUT: Enter .ctf file name (excluding the .ctf)
sample_name = 'yourFileName';

% USER INPUT: Title for graph
title = 'yourTitle';

%% Define the parameters 

% USER INPUT: Header size of the original head file. Open text file. 
header_size = []; 

% USER INPUT: misorientation angles for SG and GS and cutoff for
% SG_piezometer
% For the Goddard 2020 subgrain piezometer set sg_min and cutoff to 1 degree. 

gb_min = [];
sg_min = [];
cutoff = []; 

% USER INPUT: Phase, must match that in the CS file.

phase = 'yourPhase';

% USER INPUT: Crystal system 

%  Common crystal systems 
% 'Quartz = trigonal'   'Calcite = trigonal'    
% 'Enstatite  Opx AV77 = orthorhombic'  'Forsterite = orthorhombic'

crystal = 'yourCrystalSystem';
% test, if you want to do a smaller data set to test the code 1 = YES, 0 =
% NO

test = [];

% Following figures will be created if 1 and not if 0
Phase_map = [];
Band_contrast = [];

Input_CTF = [dirname sample_name '.ctf'];
A = importdata(Input_CTF);
[fname_new, stepx_all, Step_size_SG_size] = undersampling_fun(Int_max, dirname, sample_name, header_size,gb_min,sg_min,test, Phase_map, Band_contrast, nx, ny, cutoff, phase, crystal);

close all 

figure 
    plot(Step_size_SG_size(1)./stepx_all, Step_size_SG_size/Step_size_SG_size(1),'-o', 'LineWidth', 3, 'color', [0.49 0.34 0.75], 'MarkerSize', 7);
    set(0,'DefaultAxesFontSize',15,'DefaultAxesFontName','helvetica','DefaultAxesTickLength',[.03 .02],'DefaultAxesLineWidth',2);
    set(gca,'fontsize',15);
    ylabel('Intercept variation factor ,\bf\lambda\rm/\bf\lambda\rm_b_e_s_t', 'FontSize',15);
    xlabel('Pixels per intercept, \bf\lambda\rm_b_e_s_t/step size', 'FontSize', 15);
    title(title, 'FontSize', 15)
