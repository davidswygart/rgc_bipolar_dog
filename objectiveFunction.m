function err = objectiveFunction(newParams, rgc1, rgc2, modelParams)
%% %% run the model for RGC1
modelParams.CSR = newParams(1) * modelParams.CSR; % need to undo normalization
modelParams.sSize = newParams(3) * modelParams.sSize; % need to undo normalization

modelOut = calcRgcResp(modelParams, rgc1, 'no Plot');
r2 = modelOut.r2;

%% %% run the model for RGC2
modelParams.CSR = newParams(2) * modelParams.CSR; % need to undo normalization
modelOut = calcRgcResp(modelParams, rgc2, 'no Plot');

%% average R2
r2 = [r2 ; modelOut.r2];

err = 1-mean(r2);
end