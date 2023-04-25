function prep_mtex(version, SGPpath)

if nargin < 1
    mtex_version = '5.1.1SGP';
else
    mtex_version = version;
end

if nargin < 2
<<<<<<< HEAD
    SGPpath = '/nfs/a285/homes/eejdm/software/SGPiezometry';
=======
    SGPpath = '/nfs/a285/homes/eejdm/SGPiezometry';
>>>>>>> 5021c4d97e2bf9a06aad1b4588ea3db980fcff51
else
    SGPpath;
end

curdir = pwd;

mtex = [SGPpath, filesep, 'mtex-', mtex_version];

<<<<<<< HEAD
fprintf('mtex location: %s\n', mtex)
=======
fprintf('mtex location: %s', mtex)
>>>>>>> 5021c4d97e2bf9a06aad1b4588ea3db980fcff51

cd(mtex)

install_mtex

addpath(genpath(mtex))
addpath('/nfs/a285/homes/eejdm/SGPiezometry')

cd(curdir)

<<<<<<< HEAD
fprintf('Ready to roll!!!\n')
=======
fprintf('Ready to roll!!!\n')

>>>>>>> 5021c4d97e2bf9a06aad1b4588ea3db980fcff51
