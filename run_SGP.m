%% Run_SGP
% Run the SubGrain Piezometry scripts of Goddard et al., (2020).
% As sensitivity tests are carried out, you may need to change the
% parameters in the config file

% Jack McGrath, 2023, Uni of Leeds

config = 'CPA2_again.conf';

%% Select which scripts to run
% Sensitivity Tests
doLin = 0;
doUnder = 1;
doArea = 1;

% Final Calculation
doStress = 1;

% Reset figures
resetFigs = 1;

[plotPhase] = getparam(config, 'Phase_map');
[plotBC] = getparam(config, 'Band_contrast');

if resetFigs
    close all
end

%% Create directory to store outputs
par = readconfigfile(config);

if strcmpi(par.file(end-3:end), '.ctf')
    outdir = [par.file(1:end-4) '_outputs'];
    if ~exist(outdir, 'dir')
        mkdir(outdir)
    end
else
    error('Inputfile is not in .ctf format')
end

confbase = config(1:end-5);

%% Run scripts, and backup the config file
fprintf('Analysing Sample %s\n', par.file)

if doLin
    fprintf('Runing Linear Intercepts Test...\n')
    copyfile(config, [outdir filesep confbase '_NoIntercepts.conf'])
    No_intercepts_check(config)
end

if doUnder
    fprintf('Runing Undersampling Test...\n')
    copyfile(config, [outdir filesep confbase '_Undersample.conf'])
    Undersampling_Step_Size(config)
end

[newPhase, newBC] = togglePMBC(config, plotPhase, plotBC, doUnder, doArea, doStress, 2);

if doArea
    fprintf('Runing Map Area Reduction Test...\n')
    copyfile(config, [outdir filesep confbase '_AreaReduction.conf'])
    Area_Analysis_reduction(config)
end

[newPhase, newBC] = togglePMBC(config, newPhase, newBC, doUnder, doArea, doStress, 3);

if doStress
    fprintf('Running Subgrain Piezometer...\n')
    copyfile(config, [outdir filesep confbase '_ProcessEBSD.conf'])
    ProcessEBSD_LinearIntercepts(config)
end

% Reset phase map and BC plots to original
if newPhase ~= plotPhase
    edit_config(config, 'Phase_map', plotPhase)
end

if newBC ~= plotBC
    edit_config(config, 'Band_contrast', plotBC)
end


%% Extra functions
function edit_config(config, param, val);
% edit_config changes a toggle in the config file (ie only 0 and 1)
% config: name of the .conf file
% param:  parameter that we want to change
% val:    new value to implement

[par] = readconfigfile(config);
par.(param) = val;
% Read config file
fid = fopen(config);
conf = textscan(fid, '%s','Delimiter','\n','CollectOutput',true);
fclose(fid);

for ii = 1:size(conf{1},1)
    if startsWith(conf{1}{ii}, param)
        old = split(conf{1}{ii});
        conf{1}{ii} = sprintf('%s: %.0f',param, val);
        fprintf('Change Parameter %s from %s to %.0f\n', param, old{2}, val)
        break
    end
end

% Write new config file
fid = fopen(config, 'w');
for ii = 1:size(conf{1},1)
    fprintf(fid,'%s\n', conf{1}{ii});
end
fclose(fid);
end


function [val] = getparam(config, param)
% getparam retreives a parameter value from the config file (in the event
% of the paramteter listed several times, it uses the first)

[par] = readconfigfile(config);
val = par.(param);

end


function [newPhase, newBC] = togglePMBC(config, plotPhase, plotBC, doUnder, doArea, doStress, step)
% Function to run of the plotting of phasemaps and band contrast repeatedly
newPhase = plotPhase;
newBC = plotBC;

% Turn off if plotted in Undersampling and about to do more
if step == 2
    if doUnder == 1
        if doArea || doStress
            if plotPhase
                edit_config(config, 'Phase_map', 0)
                newPhase = 0;
            end
            
            if plotBC
                edit_config(config, 'Band_contrast', 0)
                newBC = 0;
            end
        end
    end
end

% Turn off if done Undersampling & Area and about to do Stress
if step == 3
    if doUnder == 1 || doArea == 1
        if doStress
            if plotPhase
                edit_config(config, 'Phase_map', 0)
                newPhase = 0;
            end
            
            if plotBC
                edit_config(config, 'Band_contrast', 0)
                newBC = 0;
            end
        end
    end
end

end
