function ProcessEBSD_Linearintercepts(config_file)
%% ProcessEBSD_LinearIntercepts - measures mean line intercept length
% Rellie M. Goddard, July

% This function measures the mean line intercept length and offers the option of providing a
% equivalent stress from the Goddard et al. (2020) subgrain-size piezometer

% Required functions:
% *ProcessEBSD_fun.m
% *LinearIntercepts_fun.m

%% Required user inputs:
% * nx: The number of intercept lines, chosen based on analysis from
%       No_intercepts_check.m.
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
%       to 0
% * Check_different_misorientation: To measure the mean line intercept length for minimum misorientation angle between 1 and 10 degrees, set to 1.
%       Otherwise set to 0.
% * SG_piezometer: To calculate equivalent stress straight from measured subgrain size, set to 1. Otherwise set to 0.
% * Piezometer_choice: If SG_piezometer == 1, Piezometer_choice enables the choice between the subgrain-size piezometers with, and without the
%        Holyoke and Kronenberg (2010) friction correct.
% * Burgers: Burgers vector of phase of interest
% * Shear_M: shear modulus of the phase of interest
%
%% Additional user inputs produced by MTEX
% * CS: Crystal symmetry class variable for all indexed phaes in EBSD map.
% * pname: Path to data (e.g., 'C:/Users/admin/data/')
% * fname: File name  combined with path
%
% Results:
%       If input Check_different_misorientation = [1], a plot of mean line intercept length (y-axis)
%       plotted against the defined critical misorientation angle (x-axis). A sample which contains subrgains will show
%       smaller mean line intercept lengths for critical misorientation angles of < 5° than at 10°.
%       A figure of the intercept analysis and a histogram of the line intercept lengths including the calculated arithmetic mean.
%       Optional outputs included a band contrast map and a phase map if inputs Band_contrast and Phase_map both = [1].
%       If SG_piezometer = 1, a stress calculated from one of the Goddard et al., (2020) subgrain-size piezometer will also be outputted.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data import
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all

[par] = readconfigfile(config_file);

% USER INPUT: Data inport information from MTEX
% This information is produced automatically by the MTEX import wizard
% Paste in your CS, plotting conventions, pname, and fname here.

% Specify Crystal and Specimen Symmetries
% crystal symmetry
% Specify Crystal and Specimen Symmetries
% crystal symmetry
CS =  par.CS;
% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% Specify File Names
fname = par.fname;

%% USER INPUT: Required information (taken from config)
nx = par.nx; % Number of intercept lines
gb_min = par.gb_min; % Minimum misorientation for grain boundary (for figures)
sg_min = par.sg_min; % Minimum misorientation for subgrain boundary (for figures)
cutoff = par.cutoff; % Minimum misorientation for subgrain boundary (for calculation)
phase = par.phase; % Phase to measure. Must match a phase present in CS.
crystal = par.crystal; % Crystal system of phase to measure.
Phase_map = par.Phase_map; % Set to 1 to plot a phase map of the EBSD data.
Band_contrast = par.Band_contrast; % Set to 1 to plot a band contrast map.
test = par.test; % Set to 1 to speed up analysis when troubleshooting.
Check_different_misorientation =  par.Check_different_misorientations; % To run minimum misorientations used to define a subgrain size boundary from 1 to 10 degrees, set to 1. Otherwise, set to 0
SG_piezometer = par.SG_piezometer; % if user wishes to use the same shear moduli and Burgers vector as in the subgrain-size piezometer paper then SG_piezometer = [1] will output a stress.
Burgers = par.Burgers; % Burgers vector of phase of interest. Values used in the Goddard et al. (2020) papar are: 5.1*10^-4 microns for quartz and 4.75*10^-4 microns for olivine.
Shear_M = par.Shear_M; % Shear modulus of phase of interest. Values used in the Goddard et al. (2020) paper are: 4.2*10^4 MPa (Quartz), 7.78*10^4 MPa (Fo90), and 6.26*10^4 MPa(Fo50).
plot_flg = par.plt_flg; % set the iteration numbers that you would like to plot (0-9). Keep empty to plot none, set to 10 for all
dev = par.dev; % Set to 1 to use development codes
voronoi = par.voronoi; % Use vornonoi decomposition
%% END OF USER INPUTS

%% Create empty arrays to store data within
%% Programmatically calculate other necessary variables
ny = nx; % Set number of intercepts in y-direction to equal number of intercepts in the x-direction.

%% Create empty arrays to store data
Mis_orientation = [];
Subgrain_mis_ori = [];
Lengths_X_1 =[];
Lengths_Y_1 =[];

%% Calculate and plot
[ebsd,grains,subgrains] = ProcessEBSD_fun(fname,gb_min,sg_min, CS, test, Phase_map, Band_contrast, voronoi);
fprintf('Data Loaded\n')
% Linear intercept analysis

results = [par.file(1:end-4) '_outputs' filesep par.file(1:end-4) '_results.txt'];
fid = fopen(results, 'w');
fprintf(fid,'ProcessESB_LinearIntercepts Results\n');
fprintf(fid,'Sample:\t\t\t%s\n', par.file);
fprintf(fid,'N_intercepts:\t%.0f\n', nx);


if Check_different_misorientation == 1
    fprintf(fid,'\nChecking Different Misorientations\n');
    for cutoff = 1:1:10
        fprintf('Check %.0f degree Misorientation Angle\n', cutoff)
        Mis_orientation = [Mis_orientation, cutoff];
        [Mean_Lengths_X,Mean_Lengths_Y, lengths_x, lengths_y] = LinearIntercepts_fun(ebsd,nx,ny,cutoff,phase,crystal, plot_flg, dev);
        store = [];
        store = [lengths_x;lengths_y];
        Subgrain_mis_ori = [Subgrain_mis_ori, (sum(store)/length(store))];
        if cutoff == 1
            Lengths_X_1 = [Lengths_X_1, lengths_x];
            Lengths_Y_1 = [Lengths_Y_1, lengths_y];
        end
    end
    
    % Add a line of best fit
    MA = 0;
    SG = 0;
    for a = 1:10
        MA(end+1) = Mis_orientation(a);
        SG(end+1) = Subgrain_mis_ori(a);
        fprintf(fid,'Misorientation:\t%.0f\260\t\tLambda:\t%.2f \xB5m\n', MA(end), SG(end));
    end
    
    figure
    scatter(Mis_orientation,Subgrain_mis_ori,50, 'filled', 'black');
    hold on
    
    % Specify the limits of the axis
    xlim([0 10]);
    hold on
    ylim_old = max(Subgrain_mis_ori);
    hold on
    ylim = ([0 2*ylim_old]);
    hold on
    
    % Add labels
    xlabel('Minimum misorientation angle ({\circ})')
    ylabel('\it\lambda\it (\mum)')
    hold on
    box on
    
    % Adding a smooth line
    Z = smooth(MA,SG, 'sgolay');
    plot(MA, Z, 'black','LineWidth',2);
    box on
    
    cutoff = 1;

elseif Check_different_misorientation == 0
    fprintf('Check %.0f degree Misorientation Angle\n', cutoff)
    [Mean_Lengths_X,Mean_Lengths_Y, lengths_x, lengths_y] = LinearIntercepts_fun(ebsd,nx,ny,cutoff,phase,crystal, plot_flg, dev);
    Lengths_X_1 = [Lengths_X_1, lengths_x];
    Lengths_Y_1 = [Lengths_Y_1, lengths_y];
    fprintf(fid,'Misorientation:\t%.0f\260\t\tLambda:\t%.2f \xB5m\n', cutoff, SG(end));
end

fprintf('Plotting Line Intercept Histogram\n')
% Plot histogram of line intercepts
% Number of bins
figure
bin=15;

d_h = Lengths_X_1;
d_v = Lengths_Y_1;
d = [d_h;d_v];

% Calculate the arithmetic mean
a_mean_RG = sum(d)/length(d);

% Plot linear scale histogram
hist(d,15);

xlabel('Linear Intercept Length (\mum)')
ylabel('Probability')
title(['arithmetic mean = ' num2str(round(a_mean_RG, 2)) ' \mum'])
box on

fprintf(fid,'\nUsed Line Intercept Length (lambda)\n');
fprintf(fid,'Misorientation:\t%.0f\260\t\tLambda:\t%.2f \xB5m\n', cutoff, round(a_mean_RG, 2));

% Getting a stress from the Goddard et al. (2020) piezometer
if SG_piezometer == 1
    fprintf('Calculating Stresses\n')
    fprintf(fid,'\nCalculating Stresses\n');
    fprintf(fid,'Burgers:\t\t%.2e \xB5m\nShear_M:\t\t%.2e MPa\n',Burgers, Shear_M);
    Equivalent_stress = [];
    [Equivalent_stress(1)] = Stress_Calulation_fun(Burgers,Shear_M,1,a_mean_RG);
    [Equivalent_stress(2)] = Stress_Calulation_fun(Burgers,Shear_M,2,a_mean_RG);
    
    % Print Von Mises Equilivant_Stress
    fprintf('\tCalibrated Stress:\t%.2f MPa\n', Equivalent_stress(1))
    fprintf('\tUnCalibrated Stress:\t%.2f MPa\n', Equivalent_stress(2))
    fprintf(fid,'Calibrated:\t\t%.2f MPa\n', Equivalent_stress(1));
    fprintf(fid,'UnCalibrated:\t%.2f MPa\n', Equivalent_stress(2));
end

fclose(fid);
end