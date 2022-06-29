%% import trace and choose sample synapse locations
synPerMicron = .3;
filename = 'C:\Users\david\Desktop\2P_traces\ON_alpha\withPhys\090617Bc2.swc';
sampleLoc = getRandSyns(filename,synPerMicron);
%%
sSize = 600; % 2 SD surround
CSR = 2; % center / surround
% paramStart = [sSize, CSR];
paramStart = CSR;

spotSizes = nodeData.spotSize;
realResp = nodeData.stimInterval_charge.mean_c*-1;
realResp = realResp/max(realResp);

f = @(x)modelRgcSms(x, sampleLoc, spotSizes, realResp);
% 
% op = optimoptions('fminunc');
% op.MaxFunctionEvaluations = 6e+02;

output = fminunc(f,paramStart)