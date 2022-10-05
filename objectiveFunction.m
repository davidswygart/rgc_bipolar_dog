function err = objectiveFunction(newParams, rgcs, modelParams)
% unpack the new fitting values
modelParams.CSR = newParams(1) * modelParams.CSR; % need to undo normalization
modelParams.sSize = newParams(2) * modelParams.sSize; % need to undo normalization

% run the model and get the error
modelOut = calcRgcResp(rgcs, modelParams,'no Plot');
err = mean(modelOut.MAE);
end