function prep_mtex(version, SGPpath)

% Set up mtex version and path variables
if nargin < 1
    mtex_version = '5.1.1SGP';
else
    mtex_version = version;
end

if nargin < 2
    SGPpath = '/nfs/a285/homes/eejdm/software/SGPiezometry';
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
addpath('/nfs/a285/homes/eejdm/SGPiezometry')

% Turn name conflict warning back on
warning('on', 'MATLAB:dispatcher:nameConflict')

% Return to original working directory
cd(curdir)

fprintf('Ready to roll!!!\n')
