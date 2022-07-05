function [allFits,crossVal,crossValOtherRGC] = fitAndCrossVal(rgcTable,otherRgcType)
%% set constants and starting parameters
cSize = 44; % 2 SD center
sSize = 200;% 2 SD surround (starting parameter) (pix = 161)(alpha = 252)
res = 5; % resolution (um/pixel)
CSR = 1.6; % center / surround starting parameter)(pix = 1.11)(alpha = 2.03)

modelParams = table(cSize,sSize,CSR,res,'VariableNames', ["cSize","sSize","CSR","res"]);
fitParams = [CSR, sSize];

%% set constraints
minSize = 50;
maxSize = 1000;
minCSR = .5;
maxCSR = 5;

%% choose holdout for cross validation
nHoldOut = 2;
totalRGCs = size(rgcTable,1);
rcgInds = 1:totalRGCs;
holdOutInds = nchoosek(rcgInds, nHoldOut);

nperms = size(holdOutInds,1);
%% Optimize parameters (CSR and surround size), and run cross validation
n = nan(nperms,1);

allFits = repmat(modelParams(1,:),[nperms,1]);
allFits = [allFits, table(n,n,'VariableNames',["MSE","exitflag"])];

c = cell(nperms,1);
crossVal = table(c,c,c,c,'VariableNames',["RealSs","ModelSs","RealResp","ModelResp"]);
crossValOtherRGC = crossVal;

for i=1:nperms
    %% fit to a subset of RGCs
    fitInds = rcgInds(~ismember(rcgInds, holdOutInds(i,:)));
    
    fitTable = rgcTable(fitInds,:);
    f = @(x)modelError(x, fitTable, modelParams);
    [solution, MSE, exitflag] = fmincon(f,fitParams,[],[],[],[],[minCSR,minSize],[maxCSR,maxSize]);
    
    %% save the fit values
    allFits.CSR(i) = solution(1);
    allFits.sSize(i) = solution(2);
    allFits.MSE(i) = MSE;
    allFits.exitflag(i) = exitflag;
    
    %% cross validate on the rest of this RGC type
    testInds = rcgInds(~ismember(rcgInds, holdOutInds(i,:)));
    testTable = rgcTable(testInds,:);
    modelOut = calcRgcResp(allFits(i,1:4), testTable);
    
    %% save the cross validation results for this RGC type
    crossVal.RealSs(i) = {testTable.measuredSS};
    crossVal.ModelSs(i) = {modelOut.modelSS};
    crossVal.RealResp(i) = {testTable.realResp};
    crossVal.ModelResp(i) = {modelOut.modelResp};
    
   %% cross validate on the other RGC type
    modelOut = calcRgcResp(allFits(i,1:4), otherRgcType);
    
    %% save the cross validation results for the other RGC type
    crossValOtherRGC.RealSs(i) = {otherRgcType.measuredSS};
    crossValOtherRGC.ModelSs(i) = {modelOut.modelSS};
    crossValOtherRGC.RealResp(i) = {otherRgcType.realResp};
    crossValOtherRGC.ModelResp(i) = {modelOut.modelResp};
end
end
