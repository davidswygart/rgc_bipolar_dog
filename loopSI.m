cSize = 43; % 2 SD center
sSize = 127; % 2 SD surround
CSR = 1.07; % center / surround
res = 2; % resolution (um/pixel)
synPerMicron = .3;

folder = 'C:\Users\david\Desktop\2P_traces\ON_alpha';

minSpot = 30;
maxSpot = 1200;
numSpots = 50;
spotSizes = logspace(log(minSpot)/log(10), log(maxSpot)/log(10), numSpots);

cd(folder)
files = dir('*.swc');
files = {files.name};

suppressions = nan(size(files));

for i = 1:length(files)
    display(files{i})
    filename = files{i};

    %% import trace and choose sample synapse locations
    figure(10)
    sampleLoc = getRandSyns(filename,synPerMicron);

    %% Bipolar DoG
    figure(11)
    [bipolarDog] = genBipolarFilter(cSize, CSR, sSize, res);

    % Spots Multi Size response for Bipolar
    figure(12)
    smsExperiment(bipolarDog, res, spotSizes)
    title('Spots multi-size response of bipolar cell')



    %% create image of bipolar input based on sample synapses
    figure(13)
    rgcDog = genRgcDog(sampleLoc,bipolarDog,res);

    %% Run spots multi size on RGC
    figure(14)
    modelRgcResp = smsExperiment(rgcDog, res, spotSizes);
    title('Spots multi-size response of RGC')
    plot(spotSizes,modelRgcResp)
    
    suppressions(i) = (1 - modelRgcResp(end)/max(modelRgcResp))*100;

end