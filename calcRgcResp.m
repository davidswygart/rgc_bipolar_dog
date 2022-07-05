function modelOut = calcRgcResp(modelParams, rgcTable)
res = modelParams.res;

%% make bipolar DoG
[bipolarDog] = genBipolarFilter(modelParams, 'no plot');

%% create image of bipolar input based on sample synapses for each RGC
numRGCs = length(rgcTable.randSyn);

ctemp = cell(numRGCs,1);
stemp = strings(numRGCs,1);
dtemp = nan(numRGCs,1);

modelOut = table(stemp,ctemp,ctemp,dtemp,dtemp,dtemp,...
    'VariableNames', ["cellName","spotSizes","modelResp","respErr","modelSS","SsErr"]);

for i = 1:numRGCs
    modelOut.cellName(i) = rgcTable.cellName(i);
    modelOut.spotSizes{i} = rgcTable.spotSizes{i};
    
    rgcDog = genRgcDog(rgcTable.randSyn{i},bipolarDog,res,'no plot');
    rgcResp = smsExperiment(rgcDog, res, rgcTable.spotSizes{i}, 'no plot');
    suppression = 100*(1-rgcResp(end)/max(rgcResp));
    
    modelOut.modelResp(i) = {rgcResp};
    modelOut.respErr(i) = mean((rgcResp - rgcTable.realResp{i}).^2);
    modelOut.modelSS(i) = suppression;
    modelOut.SsErr(i) = suppression-rgcTable.measuredSS(i);
end