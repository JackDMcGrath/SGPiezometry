function [par] = readconfigfile(cfgfile)
%=================================================================
% function [par] = readconfigfile(cfgfile)
%-----------------------------------------------------------------
% Function to get parameter values from a config file.
%                                                                  
% INPUT:                                                           
%   cfgfile: path to parameter text file (e.g. sample.conf)
% OUTPUT:                                                          
%   par:  structure containing general parameters
%   
% Adapted from the velmap readparfile
%
% Jack McGrath, 2023, Uni of Leeds
%                                                                  
% NOTE: use '%' for comments in config file, and ': ' to seperate names and
% values (e.g. plt_flg:   1)
%=================================================================

%% open config file

% test that config file exists
if ~isfile(cfgfile)
    disp('Config file not found, continuing with default values.')
end

% load the config file as a cell array
cfgcell = readcell(cfgfile,'FileType','text','CommentStyle','%','Delimiter',':');

%% paths

% file path
par.pname = getparval(cfgcell,'pname',[]);

% file name
par.file = getparval(cfgcell,'file',[]);

par.fname = [par.pname filesep par.file];
%% Phases and Crystal Symmetry
calc_CS = getparval(cfgcell,'calc_CS',1);

if calc_CS
    ebsd = loadEBSD(par.fname, 'convertEuler2SpatialReferenceFrame');
    par.CS = ebsd.CSList;
else
    n_par = size(cfgcell,1);
    par.CS = {};
    for ii = 1:n_par
        if strcmpi(cfgcell{ii,1}, 'CS');
            if strcmpi(cfgcell{ii,2}, 'NotIndexed')
                par.CS{size(par.CS,1) + 1} = 'NotIndexed';
            elseif strfind(cfgcell{ii,2}, 'crystalSymmetry')
                crys = split(strrep(cfgcell{ii,2},',',' '));
                symm = crys{find(ismember(crys, 'crystalSymmetry')) + 1};
                mineral = crys{find(ismember(crys, 'mineral')) + 1};
                color = crys{find(ismember(crys, 'color')) + 1};
                par.CS{size(par.CS,2) + 1} = crystalSymmetry(symm, 'mineral', mineral, 'color', color);
            end
        end
    end
end

par.phase = getparval(cfgcell,'phase',[]);
par.crystal = getparval(cfgcell,'crystal',[]);

%% General Parameters
par.nx = getparval(cfgcell,'nx',40);
par.cutoff = getparval(cfgcell,'cutoff',1);
par.test = getparval(cfgcell,'test',0);
par.dev = getparval(cfgcell,'dev',1);
par.voronoi = getparval(cfgcell,'voronoi',1);

% Plotting toggles
par.gb_min = getparval(cfgcell,'gb_min',10);
par.sg_min = getparval(cfgcell,'sg_min',2);
par.Phase_map = getparval(cfgcell,'Phase_map',0);
par.Band_contrast = getparval(cfgcell,'Band_contrast',0);
par.plt_flg = getparval(cfgcell,'plt_flag',0);
par.plt_its = getparval(cfgcell,'plt_its',[]);

% Script specific
par.include_low = getparval(cfgcell,'include_low',0);
par.Int_max = getparval(cfgcell,'Int_max', 10);
par.title_text = getparval(cfgcell,'title_text',par.file);
par.header_size = getparval(cfgcell,'header_size',16);
par.Check_different_misorientations = getparval(cfgcell,'Check_different_misorientations',0);
par.SG_piezometer = getparval(cfgcell,'SG_piezometer',1);

if strfind(lower(par.phase),'quartz')
    par.Burgers = str2num(getparval(cfgcell,'Burgers','5.1e-4'));
    par.Shear_M = str2num(getparval(cfgcell,'Shear_M','4.2e4'));
elseif strfind(lower(par.phase),'olivine')
    par.Burgers = str2num(getparval(cfgcell,'Burgers','4.75e-4'));
    par.Shear_M = str2num(getparval(cfgcell,'Shear_M','6.26e4'));
else
    par.Burgers = str2num(getparval(cfgcell,'Burgers',[]));
    par.Shear_M = str2num(getparval(cfgcell,'Shear_M',[]));
end


%% getparval ==============================================================
% cfgcell: n-by-2 cell array containing parameters
% parstring: name of desired parameter
% defval: default val if parameter is not found
% indn: index to use when multiple matches are found
function [val] = getparval(cfgcell,parstring,defval,indn)
    
    if nargin ~= 4
        indn = 1;
    end
    
    try
%         val = cfgcell{strcmp(cfgcell(:,1), parstring),2};
        indx = find(strcmp(cfgcell(:,1), parstring));
        val = cfgcell{indx(indn),2};
        if ismissing(val)
            val = defval;
        end
    catch
        val = defval;
    end
end

end