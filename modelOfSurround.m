%% gather real response
spotSizes = nodeData.spotSize;
realResp = nodeData.stimInterval_charge.mean_c*-1;
realResp = realResp/max(realResp);

%% import trace and choose sample synapse locations
synPerMicron = .3;
filename = 'C:\Users\david\Desktop\2P_traces\ON_alpha\withPhys\060322Ac2.swc';

figure(10)
sampleLoc = getRandSyns(filename,synPerMicron);

%% Bipolar DoG
cSize = 43; % 2 SD center
sSize = 127; % 2 SD surround
CSR = 1.53; % center / surround
res = 5; % resolution (um/pixel)


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
hold on
plot(spotSizes,realResp)

legend('model','experimental')

%calculate error
MSE = mean((realResp-modelRgcResp).^2);
text(800,0.8,['MSE = ' num2str(round(MSE,3))])
hold off
