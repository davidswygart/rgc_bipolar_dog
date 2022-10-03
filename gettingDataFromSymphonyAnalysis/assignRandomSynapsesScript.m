synPerMicron = .3;
%folder = 'C:\Users\dis006\Documents\GitHub\rgc_bipolar_dog\data\traces\pixons';
folder = 'C:\Users\dis006\Documents\GitHub\rgc_bipolar_dog\data\traces\alphas';

%% Loop through RGC tracings
cd(folder)
files = dir('*.swc');
files = {files.name};

output = table("",{0},{0},'VariableNames', ["cellName", "trace","randSyn"]);

for i = 1:length(files)
    display(files{i})
    filename = files{i};
    output.cellName(i) = filename;

    trace = importTrace(filename);
    output.trace(i,:) = {trace};

    synPerMicron = 0.3;
    output.randSyn(i,:) = {getRandSyns(trace,synPerMicron)};
end
% measuredPixON.trace = output.trace;
% measuredPixON.randSyn = output.randSyn;

measuredOnAlpha.trace = output.trace;
measuredOnAlpha.randSyn = output.randSyn;