function prep_mtex(SGPpath, mtexPath, mtexVersion)
% Function to prepare mtex and set up the correct paths. Edit the default
% path to the SGPeizometery software. Adding this script to your default
% MATLAB search path (or at softlinking to it) will mean that this script
% will be easily searchable, and can be launched from your data folder

% Jack McGrath, 2023, Uni of Leeds


% Set up path and mtex version variables
if nargin < 1
    SGPpath = '/nfs/a285/homes/eejdm/software/SGPiezometry';
end

if nargin < 2
    mtexPath = '/nfs/a285/homes/eejdm/software';
end

if nargin < 3
    mtexVersion = '5.1.1';
end

mtex = [mtexPath filesep 'mtex-', mtexVersion];

curdir = pwd;

fprintf('mtex location: %s\n', mtex)

% New MTEX files to be added to your matlab version
newMTEX = [SGPpath filesep 'newMTEX' filesep];
EBSD = [mtex filesep 'EBSDAnalysis' filesep '@EBSD' filesep];

copyfile([newMTEX 'findByXLocation.m'], EBSD)
copyfile([newMTEX 'findByYLocation.m'], EBSD)

% Some MTEX commands have the same name as actual matlab commands for
% compatibility reasons. Turn off warning during installation
warning('off', 'MATLAB:dispatcher:nameConflict')

% Change into the mtex folder and install mtex
cd(mtex)
install_mtex

% Add mtex and SGP to path (mtex normally added in installation, but this
% sometimes fails
addpath(genpath(mtex))
addpath(SGPpath)
addpath([SGPpath, filesep, 'SGP_functions'])

% Turn name conflict warning back on
warning('on', 'MATLAB:dispatcher:nameConflict')

% Return to original working directory
cd(curdir)

fprintf('Ready to roll!!!\n')
