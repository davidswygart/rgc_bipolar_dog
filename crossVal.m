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

%%
% %% Examine cross error and ss error
% %f = pixFitsMAE;
% %f = pixFitSquaredErr;
% f = pixFits;
% n = size(f,1);
% 
% spotSizes = rgcs.spotSizes{1};
% 
% 
% ssErr = nan(size(rgcs,1), n);
% err = nan(size(rgcs,1), n);
% resps = nan(size(rgcs,1), length(spotSizes), n);
% 
% for i=1:n
%     cv = f.crossVal{i};
%     err(:,i) = cv.MAE;
%     ssErr(:,i) = cv.SsErr;
%     resps(:,:,i) = cell2mat(cv.modelResp);
% end
% 
% %resps = permute(resps, [1,3,2]);
% %resps = 
% resps = mean(resps,3);
% 
% %%
% hold on
% for i=9:22
%     %hold off
%     %plot(spotSizes,resps(i,:))
%     %hold on
%     %plot(spotSizes, rgcs.realResp{i})
% 
%     d = rgcs.realResp{i} - resps(i,:);
%     plot(spotSizes, d)
%     
% end
% hold off
% %%
% cvInds = ~cell2mat(f.fitInds');
% 
% cvSsErr = nan(size(ssErr));
% cvSsErr(cvInds) = ssErr(cvInds);
% mcvErr = mean(cvSsErr,2,'omitnan');
% 
% 
% cvErr = nan(size(err));
% cvErr(cvInds) = err(cvInds);
% mErr = mean(cvErr,2,'omitnan');
% %%
% %histogram(mcvErr,12)
% histogram(mErr,12)
f = pixFits;
for i = 1:size(f,1)
    cv = f.crossVal{i};

    cv.spotSizes = [];
    cv.realResp = [];
    cv.measuredSS = [];
    cv.trace = [];
    cv.randSyn = [];
    cv.cImg = [];
    cv.sImg = [];
    cv.dog = [];
    f.crossVal(i) = {cv};
end

pixFits = f;


%%
for i=1:size(rgcs,1)
    min(cv.resp{i})


    %rgcs.realResp(i) = {rgcs.realResp{i} / max(rgcs.realResp{i})};
end









