cSize = 44; % 2 SD center
res = 3; % resolution (um/pixel)
sSize = 140; % 2 SD surround (starting parameter)
CSR = 1.1; % center / surround starting parameter)
synPerMicron = .3;

filename = 'C:\Users\david\Desktop\2P_traces\PixON\fit\071117Bc9.swc';
%% import trace and choose sample synapse locations
figure(10)
sampleLoc = getRandSyns(filename,synPerMicron, 'plot');

%% get real data and interpolate it for even sampling
spotSizes = nodeData.spotSize;
realResp = nodeData.stimInterval_charge.mean_c;
realResp = realResp/min(realResp);

figure(101)
clf
plot(spotSizes,realResp)

temp = spotSizes(1):15:1200;
realResp = interp1(spotSizes,realResp,temp,'pchip','extrap'); %interpolate for even sampling of error
spotSizes = temp;

hold on
plot(spotSizes,realResp)
legend('real','interpolated')

%% Optimize parameters (CSR and surround size)
paramStart = [CSR, sSize];
f = @(x)modelError(x, sampleLoc, spotSizes, realResp,cSize,res);
[solution, MSE] = fminunc(f,paramStart);

parametersAndMSE = [solution'; MSE]' %to easily copy values to excel

%% Plot the full model with the optimized parameters
CSR = solution(1);
sSize = solution(2);
modelRgcResp = plotFullModel(spotSizes,realResp,cSize,sSize,CSR,res,filename,synPerMicron);
realResp = reshape(realResp,[],1);
spotSizes = reshape(spotSizes, [],1);