rgcOfInterest = rgcs(1:8,:);
nRgcs = size(rgcOfInterest,1);

%% precomputed a 1200 um wide distance image (largest spot size)
res = 5;
[x,y] = ndgrid(-600 : res : 600);
modelParams.distImage = sqrt(x.^2 + y.^2);

%% set surround size as fit to Pix (will be held constant)
modelParams.sSize = 75.0001;

%% run loop changing CSR
starting_CSR = 1.1; % start with the assumption of PixON best fit CSR
% inhDecay = 0:1:99;
allCSR = starting_CSR ./ (1-inhDecay/100);

nPoints = length(allCSR);
sup = nan(nRgcs, nPoints);

for i = 1:nPoints
    modelParams.CSR = allCSR(i);
    tableOut = calcRgcResp(rgcOfInterest, modelParams,  'no plot');
    sup(:,i) = tableOut.sup;
end
%%
avgSup = mean(sup,1)';
stdSup = std(sup,0,1)';

%%
% vFall = activeDrop;
% vFall = passiveDrop;
% edges = 0:.02:1;
% 
% [N,edges] = histcounts(vFall,edges);
% edges = edges';
% N = N';
%% loop through to create bipolar RFs
syn = zeros(301,301);
syn(151,151) = 1;
cSig = 22;
sSig = 75;
filtSize =6*ceil(sSig)+1;

cImg = imgaussfilt(syn,cSig, 'FilterSize', filtSize);
sImg = imgaussfilt(syn,sSig, 'FilterSize', filtSize);

allCSR = [1.1, 1.5];

resp = nan(21,nRgcs);
for i=1:length(allCSR)
    dog = allCSR(i)* cImg - sImg;
    trace = sum(dog,2);
    trace = trace / max(trace);
    modelParams.CSR = allCSR(i);
    tableOut = calcRgcResp(rgcOfInterest, modelParams,  'no plot');
    
    for r=1:size(tableOut,1)
        resp(:,r) = tableOut.resp{r}';
    end
    
    avgResp = mean(resp,2);
    stdResp = std(resp,0,2) / max(avgResp);
    
    avgResp = avgResp / max(avgResp);


end
%%
z = zeros(1001,1001);
z(500,500) = 1;

cImg = imgaussfilt(z, 120, "FilterSize", 1001);
cImg = cImg / max(cImg(:));
sImg = imgaussfilt(z, 300, "FilterSize", 1001);
sImg = -sImg / max(sImg(:));

dog1 = cImg + sImg / 1.65;
dog2 = cImg + sImg / 5;

dog1 = dog1 / max(dog1(:));
dog2 = dog2 / max(dog2(:));


figure(2)
subplot(2,2,1)
imagesc(cImg)
title('cImg')
clim([-1,1])

subplot(2,2,2)
imagesc(sImg)
title('sImg')
clim([-1,1])

subplot(2,2,3)
imagesc(dog1)
title('dog strong surround')
clim([-1,1])

subplot(2,2,4)
imagesc(dog2)
title('dog weak surround')
clim([-1,1])

colormap(c)
