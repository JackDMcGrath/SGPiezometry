%% Electron Backscatter Diffraction Data (The Class @EBSD)
% This section describes the class *EBSD* and gives an overview over the
% functionality that MTEX offers to analyze EBSD data.
%
%% Contents
%
%% Class Description 
% 
% The following mindmap might give a basic idea about EBSD data
% analyis in MTEX, with the ability of <GrainReconstruction.html grain
% modelling> for spatial data. It offers various way of interpreting
% individual orientation measurements, i.e. in terms of quantifying
% macro-,micro- and  mesotexture.
%
% <<grain.png>>
%
%% SUB: Import of EBSD Data
%
% The most comfortable way to import EBSD data into MTEX is to use
% the import wizard, which can be started by the command
%
import_wizard('ebsd')

%%
% If the dataset is in a format supported by MTEX, the import wizard generates
% a script which imports the data. More information about the import wizard
% and a list of supported file formats can be found
% <ImportEBSDData.html,here>. A typical script generated by the import 
% wizard looks a follows.


cs = crystalSymmetry('m-3m','mineral','Fe');      % crystal symmetry

% file names
fname = fullfile(mtexDataPath,'EBSD','85_829grad_07_09_06.txt');

% load data
ebsd = loadEBSD(fname,'CS',cs,... 
                'interface','generic','Bunge','ignorePhase',[0 2],...
                 'ColumnNames', { 'Phase' 'x' 'y' 'Euler 1' 'Euler 2' 'Euler 3'},...
                 'Columns', [2 3 4 5 6 7])

%% SUB: Plotting EBSD Data
%
% EBSD data are plotted using the command <EBSD.plot.html,plot>.
% It assigns a color to each orientation and plots a map of these colors.
% There are several options to specify the way the colors are assigned.

ipfKey = ipfColorKey(ebsd);
plot(ebsd,ipfKey.orientation2color(ebsd.orientations))

%%
% In order to understand the color coding, one can plot the coloring of the
% corresponding inverse pole figure via

plot(ipfKey)
hold on
plotIPDF(ebsd('Fe').orientations,xvector,'markerSize',3,'points',500,'marker','o','markerfacecolor','none','markeredgecolor','k')
hold off

%% SUB: Modify EBSD Data
%
% MTEX offers a lot of operations to analyze and manipulate EBSD data, e.g.
%
% * plot pole figures of EBSD data
% * rotate EBSD data
% * find outliers
% * remove specific measurements
% * combine EBSD data from several measurements
% * compute an ODF
%
% An exhaustive introduction how to analyze and modify EBSD data can be found
% <EBSDModifyData.html here>

%% SUB: Calculate an ODF from EBSD Data
%
% The command <EBSD.calcODF.html calcODF>  performs an ODF calculation
% from EBSD data using kernel density estimation EBSD data. For a precise
% explanation of the algorithm and the available options please look at
% <EBSD2odf.html here>. 

odf = calcODF(ebsd('Fe').orientations,'halfwidth',10*degree)
plotPDF(odf,Miller(1,0,0,odf.CS),'antipodal')


%% SUB: Simulate EBSD Data
%
% Simulating EBSD data from a given ODF is useful to analyze the stability of the 
% ODF estimation process. There is an <EBSDSimulation_demo.html example> demonstrating 
% how to determine the number of individual orientation measurements to estimate the 
% ODF up to a given error. The MTEX command to simulate EBSD data is
% <ODF.calcEBSD.html calcEBSD>, e.g.

ori = calcOrientations(unimodalODF(orientation.id(cs)),500)
plotPDF(ori,Miller(1,0,0,cs),'antipodal','MarkerSize',3)

%% SUB: Demo
%
% For a more exhaustive description of the EBSD class have a look at the 
% <ebsd_demo.html EBSD demo>!
% 
