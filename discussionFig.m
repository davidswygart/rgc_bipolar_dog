alphas = rgcs(1:8,:);

%% precomputed a 1200 um wide distance image (largest spot size)
res = 5;
[x,y] = ndgrid(-600 : res : 600);
modelParams.distImage = sqrt(x.^2 + y.^2);

%% set surround size as fit to Pix (will be held constant)
modelParams.sSize = 75.0001;

%% run loop changing CSR
starting_CSR = 1.09833;

Vrib = 1:-.01:.05;

nPoints = length(Vrib);

allCSR = starting_CSR ./ Vrib;

sup = nan(8, nPoints);

for i = 1:nPoints
    modelParams.CSR = allCSR(i);
    tableOut = calcRgcResp(alphas, modelParams,  'no plot');
    sup(:,i) = tableOut.sup;
end
%%
avgSup = mean(sup,1)';
stdSup = std(sup,0,1)';

%% loop through to create bipolar RFs
syn = zeros(301,301);
syn(151,151) = 1;
cSig = 22;
sSig = 75;
filtSize =6*ceil(sSig)+1;

cImg = imgaussfilt(syn,cSig, 'FilterSize', filtSize);
sImg = imgaussfilt(syn,sSig, 'FilterSize', filtSize);

allCSR = [1.1, 1.37, 1.8, 2.7];

resp = nan(21,8);
for i=1:length(allCSR)
    dog = allCSR(i)* cImg - sImg;
    trace = sum(dog,2);
    trace = trace / max(trace);
    modelParams.CSR = allCSR(i);
    tableOut = calcRgcResp(alphas, modelParams,  'no plot');
    
    for r=1:size(tableOut,1)
        resp(:,r) = tableOut.resp{r}';
    end
    
    avgResp = mean(resp,2);
    stdResp = std(resp,0,2) / max(avgResp) / 2;
    
    avgResp = avgResp / max(avgResp);


end
