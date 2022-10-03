function msErr = modelError(newParams, rgcTable,modelParams)
%% overwrite the model parameters with our new optimized parameters
modelParams.CSR = newParams(1);
modelParams.sSize = newParams(2);

%% run the model for RGC1
modelOut = calcRgcResp(modelParams, rgcTable(1:6,:), 'no Plot');
msErr = mean(modelOut.respErr); 

%% run the model for RGC2

modelParams.CSR = newParams(3);
modelOut = calcRgcResp(modelParams, rgcTable(6:12,:), 'no Plot');

%% mean squared error
msErr = mean(modelOut.respErr) + msErr; 


sumSquareResidual
totalSumSquare

rSquared = sumSquareResidual / totalSumSquare;
end