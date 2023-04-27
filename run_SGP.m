%% Run_SGP
% Run the SubGrain Piezometry scripts of Goddard et al., (2020).
% As sensitivity tests are carried out, you may need to change the
% parameters in the config file

% Jack McGrath, 2023, Uni of Leeds

config = 'Example.conf';

%% Select which scripts to run
% Sensitivity Tests
doLinIntercept = 0;
doUndersample = 0;
doAreaReduction = 0;

% Final Calculation
doCalcStress = 1;

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

if doLinIntercept
    fprintf('Runing Linear Intercepts Test...\n')
    copyfile(config, [outdir filesep confbase '_NoIntercepts.conf'])
    No_intercepts_check(config)
end

if doUndersample
    fprintf('Runing Undersampling Test...\n')
    copyfile(config, [outdir filesep confbase '_Undersample.conf'])
    Undersampling_Step_Size(config)
end

if doAreaReduction
    fprintf('Runing Map Area Reduction Test...\n')
    copyfile(config, [outdir filesep confbase '_AreaReduction.conf'])
    Area_Analysis_reduction(config)
end

if doCalcStress
    fprintf('Running Subgrain Piezometer...\n')
    copyfile(config, [outdir filesep confbase '_ProcessEBSD.conf'])
    ProcessEBSD_LinearIntercepts(config)
end