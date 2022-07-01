spotSizes = nodeData.spotSize;
realResp = nodeData.stimInterval_charge.mean_c;

filename = 'C:\Users\david\Desktop\2P_traces\PixON\fit\072517Bc2.swc';

cSize = 44; % 2 SD center
res = 5; % resolution (um/pixel)
sSize = 110.7216; % 2 SD surround
CSR = 1.1070; % center / surround
synPerMicron = .3;

plotFullModel(spotSizes,realResp,cSize,sSize,CSR,res,filename,synPerMicron);