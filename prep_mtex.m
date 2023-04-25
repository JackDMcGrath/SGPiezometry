function prep_mtex(SGPpath, mtex_version)
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
    mtex_version = '5.1.1SGP';
else
    mtex_version = version;
end

curdir = pwd;

mtex = [SGPpath, filesep, 'mtex-', mtex_version];

fprintf('mtex location: %s\n', mtex)

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

% Turn name conflict warning back on
warning('on', 'MATLAB:dispatcher:nameConflict')

% Return to original working directory
cd(curdir)

fprintf('Ready to roll!!!\n')
