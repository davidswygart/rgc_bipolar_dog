function msErr = modelError(newParams, rgcTable,modelParams)
%% overwrite the model parameters with our new optimized parameters
modelParams.CSR = newParams(1)/100;
modelParams.sSize = newParams(2);

%% run the model
modelOut = calcRgcResp(modelParams, rgcTable, 'no Plot');

%% mean squared error
msErr = mean(modelOut.respErr)*1000; 
end