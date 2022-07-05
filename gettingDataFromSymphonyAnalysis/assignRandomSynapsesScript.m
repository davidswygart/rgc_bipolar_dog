synPerMicron = .3;
folder = 'C:\Users\david\Desktop\2P_traces\PixON';

%% Loop through RGC tracings
cd(folder)
files = dir('*.swc');
files = {files.name};

output = table({0},{0},'VariableNames', ["trace","randSyn"]);

suppressions = nan(size(files));
for i = 1:length(files)
    display(files{i})
    filename = files{i};
    figure(10)
    [sampleLoc, trace] = getRandSyns(filename,synPerMicron,'plot');
    output.trace(i,:) = {trace};
    output.randSyn(i,:) = {sampleLoc};
end
measuredPixON = [measuredPixON output];