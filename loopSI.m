%% model parameters and tracings folder
cSize = 44; % 2 SD center
res = 3; % resolution (um/pixel)
sSize = 182.779; % 2 SD surround
CSR = 1.715; % center / surround
synPerMicron = .3;

folder = 'C:\Users\david\Desktop\2P_traces\PixON\fit';

%% use linear spot sampling
spotSizes = 30:15:1200;
realResp = ones(size(spotSizes)); %I'll just grab suppression values from my excel document

%% Loop through RGC tracings
cd(folder)
files = dir('*.swc');
files = {files.name};

suppressions = nan(size(files));
for i = 1:length(files)
    display(files{i})
    filename = files{i};
    modelRgcResp = plotFullModel(spotSizes,realResp,cSize,sSize,CSR,res,filename,synPerMicron);
    suppressions(i) = 100* (1-modelRgcResp(end)/max(modelRgcResp));
end
suppressions = reshape(suppressions,[],1)