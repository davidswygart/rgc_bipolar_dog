function tableOut = calcRgcResp(rgcs, modelParams,  plotOp)

%% parameter values for surround
res = 5;
sSize = modelParams.sSize/res; % convert to pixel units
CSR = modelParams.CSR;
filtSize = 6*ceil(sSize)+1;

%% model Out: all the variables we want to save for each RGC response
numRGCs = size(rgcs,1);
tableOut = table();
tableOut.cellName = rgcs.cellName;
tableOut.type = rgcs.type;
tableOut.resp = cell(numRGCs,1);
tableOut.MAE = nan(numRGCs,1);
tableOut.sup = nan(numRGCs,1);
tableOut.supErr = nan(numRGCs,1);


%% loop and filter for RGC image
    for i = 1:numRGCs
    sImg = rgcs.randSyn{i};
    sImg = imgaussfilt(sImg,sSize, 'FilterSize', filtSize);
    dog = CSR * rgcs.cImg{i} - sImg;
    
    rgcResp = smsExperiment(dog, modelParams.distImage, rgcs.spotSizes{i});
    realResp = rgcs.realResp{i};

    if strcmp(plotOp, 'plot')
        figure(107)
        clf
        hold on
        plot(rgcs.spotSizes{i}, rgcResp)
        plot(rgcs.spotSizes{i}, realResp)
        xlabel('Spot diameter (um)')
        hold off
        legend('model response', 'real response')
    end
    
    suppression = 100*(1 - rgcResp(end)/max(rgcResp));

    tableOut.resp(i) = {rgcResp};
    tableOut.MAE(i) = mean(abs(realResp-rgcResp));
    tableOut.sup(i) = suppression;
    tableOut.supErr(i) = suppression-rgcs.measuredSS(i);
    end
end