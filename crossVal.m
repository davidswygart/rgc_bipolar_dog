% res = 5
% 
% temp = rgcs;
% for i = 1:size(rgcs,1)
% 
%     synImg = getRandSyns(rgcs.trace{i}, res);
%     temp.randSyn{i} = synImg;
%     img = imgaussfilt(synImg, 22/res, 'FilterSize', 6*ceil(22/res)+1);
%     imagesc(img)
%     temp.cImg{i} = img;
% end
% 
% 

nPerms = 2;
nTrain = 6;

nRgcs = 22;
nAlpha = 8;
nPix = 14;

%inds = num2cell(,1);
%% Fit PixONs
pixInds = shuffledInds(nPix,nTrain,nPerms);
alphaInds = shuffledInds(nAlpha, 0 ,nPerms);
inds = cat(1, alphaInds, pixInds);
inds = num2cell(inds,1);

pixFits = fitAndCrossVal(rgcs, inds);
%% Fit ON alphas
pixInds = shuffledInds(nPix,0,nPerms);
alphaInds = shuffledInds(nAlpha, nTrain ,nPerms);
inds = cat(1, alphaInds, pixInds);
inds = num2cell(inds,1);

alphaFits = fitAndCrossVal(rgcs, inds);
%% Fit balanced set of PixONs and ON alphas

pixInds = shuffledInds(nPix, nTrain/2, nPerms);
alphaInds = shuffledInds(nAlpha, nTrain/2, nPerms);
inds = cat(1, alphaInds, pixInds);
inds = num2cell(inds,1);

bothFit = fitAndCrossVal(rgcs, inds);


%% analyze fits
[fRgcs, cRgcs] = analyzeFits(pixFits);
[fRgcs, cRgcs] = analyzeFits(alphaFits);
[fRgcs, cRgcs] = analyzeFits(bothFit);

%%
figure (11)

for i = 9:21
    clf
    hold on
    plot(rgcs.spotSizes{i}, rgcs.realResp{i})
    plot(rgcs.spotSizes{i}, fRgcs.resp{i})
    legend('real','model')
    
end

%%
figure (12)
for i = 1:8
    clf
    hold on
    plot(rgcs.spotSizes{i}, rgcs.realResp{i})
    plot(rgcs.spotSizes{i}, cRgcs.resp{i})
    legend('real','model')
end

%%
fitAndCrossVal(bipolar, 1)