function [allFits,crossVals] = fitAndCrossVal(rgcTable,otherRgcType,modelParams)
%% set constants and starting parameters
CSRmult = 100;
modelParams.CSR = modelParams.CSR*CSRmult;

fitParams = [modelParams.CSR, modelParams.sSize];

%% set constraints
minSize = 50;
maxSize = 1000;
minCSR = .5*CSRmult;
maxCSR = 10*CSRmult;

%% choose holdout for cross validation
totalRGCs = size(rgcTable,1);
rcgInds = 1:totalRGCs;

if totalRGCs < 3
    holdOutInds = -1;
    nperms = 1;
else
    holdOutInds = nchoosek(rcgInds, nHoldOut);
    nperms = size(holdOutInds,1);
end

%holdOutInds = nchoosek(rcgInds, nHoldOut);
%nperms = size(holdOutInds,1);

%% Optimize parameters (CSR and surround size), and run cross validation
n = nan(nperms,1);
c = cell(nperms,1);

allFits = repmat(modelParams(1,:),[nperms,1]);
allFits = [allFits, table(n,n,c,'VariableNames',["MSE","exitflag","fitInds"])];

crossVals.thisRGC.ssErr = nan(nperms,totalRGCs);
crossVals.thisRGC.MSE = nan(nperms,totalRGCs);
crossVals.otherRGC.ssErr = nan(nperms,length(otherRgcType.cellName));
crossVals.otherRGC.MSE = nan(nperms,length(otherRgcType.cellName));

for i=1:nperms
    %% fit to a subset of RGCs
    tic
    fitInds = rcgInds(~ismember(rcgInds, holdOutInds(i,:)));
    allFits.fitInds{i} = fitInds;
    
    fitTable = rgcTable(fitInds,:);
    f = @(x)modelError(x, fitTable, modelParams);
    [solution, MSE, exitflag, output] = fmincon(f,fitParams,[],[],[],[],[minCSR,minSize],[maxCSR,maxSize]);
    
    %% save the fit values
    allFits.CSR(i) = solution(1)/CSRmult;
    allFits.sSize(i) = solution(2);
    allFits.MSE(i) = MSE/1000;
    allFits.exitflag(i) = exitflag;
    
    %% cross validate on the rest of this RGC type
    testInds = rcgInds(ismember(rcgInds, holdOutInds(i,:)));
    testTable = rgcTable(testInds,:);
    modelOut = calcRgcResp(allFits(i,1:5), testTable, 'no plot');
    crossVals.thisRGC.ssErr(i,testInds) = modelOut.SsErr;
    crossVals.thisRGC.MSE(i,testInds) = modelOut.respErr;
    
   %% cross validate on the other RGC type
    modelOut = calcRgcResp(allFits(i,1:5), otherRgcType, 'no plot');
    crossVals.otherRGC.ssErr(i,:) = modelOut.SsErr;
    crossVals.otherRGC.MSE(i,:) = modelOut.respErr;
    
    
    display(['fit ' num2str(i) ' of ' num2str(nperms)])
    toc
end
end
