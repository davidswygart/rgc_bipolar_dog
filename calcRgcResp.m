function outputTable = calcRgcResp(modelParams, rgcTable, plotOp)

%% information about precomputed random synapse image
res = modelParams.resolution;
sSize = modelParams.sSize/res; % convert to pixel units
CSR = modelParams.CSR;

%% model Out: all the variables we want to save for each RGC response
numRGCs = size(rgcTable,1);
outputTable = table();
outputTable.resp = cell(numRGCs,1);
outputTable.r2 = nan(numRGCs,1);
outputTable.modelSS = nan(numRGCs,1);
outputTable.SsErr = nan(numRGCs,1);

%% loop and filter for RGC image
for i = 1:numRGCs
    sImg = rgcTable.randSyn{i};
    filtSize = 6*ceil(sSize)+1;
    sImg = imgaussfilt(sImg,sSize, 'FilterSize', filtSize);
    
    rgcDog = rgcTable.cImg{i} - sImg / CSR;
    
    rgcResp = smsExperiment(rgcDog, modelParams.distImage, rgcTable.spotSizes{i});
    
    if strcmp(plotOp, 'plot')
        figure(107)
        clf
        hold on
        plot(rgcTable.spotSizes{i},rgcResp)
        plot(rgcTable.spotSizes{i},rgcTable.realResp{i})
        xlabel('Spot diameter (um)')
        hold off
        legend('model response', 'real response')
    end
    
    suppression = 100*(1-rgcResp(end)/max(rgcResp));

    realResp = rgcTable.realResp{i};
    sumSquareResidual = sum((realResp - rgcResp).^2);
    totSumSquare = sum((realResp - mean(realResp)).^2);
    r2 =  1 - sumSquareResidual / totSumSquare;

    outputTable.resp(i) = {rgcResp};
    outputTable.r2(i) = r2;
    outputTable.modelSS(i) = suppression;
    outputTable.SsErr(i) = suppression-rgcTable.measuredSS(i);
end