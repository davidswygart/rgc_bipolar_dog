function modelOut = calcRgcResp(modelParams, rgcTable, plotOp)

%% information about precomputed random synapse image
res = 5; %assumes 5 um/pix for precomputed synapse images

sSize = modelParams.sSize/2/res; % convert to 1 SD and account for resolution
CSR = modelParams.CSR;

%% model Out
numRGCs = length(rgcTable.randSyn);

ctemp = cell(numRGCs,1);
dtemp = nan(numRGCs,1);

modelOut = table(ctemp,dtemp,dtemp,dtemp,...
    'VariableNames', ["modelResp","respErr","modelSS","SsErr"]);

%% loop and filter for RGC image

for i = 1:numRGCs
    sImg = rgcTable.randSyn{i};
    sImg= imgaussfilt(sImg,sSize)/CSR;
    
    rgcDog = rgcTable.centerImg{i} - sImg;
    
    rgcResp = smsExperiment(rgcDog, modelParams.distanceImage{1}, rgcTable.spotSizes{i});
    
    if strcmp(plotOp, 'plot')
        figure(107)
        clf
        hold on
        plot(rgcTable.spotSizes{i},rgcResp)
        plot(rgcTable.spotSizes{i},rgcTable.realResp{i})
        xlabel('Spot diameter (um)')
        hold off
    end
    
    suppression = 100*(1-rgcResp(end)/max(rgcResp));
    
    modelOut.modelResp(i) = {rgcResp};
    modelOut.respErr(i) = mean((rgcResp - rgcTable.realResp{i}).^2);
    modelOut.modelSS(i) = suppression;
    modelOut.SsErr(i) = suppression-rgcTable.measuredSS(i);
end