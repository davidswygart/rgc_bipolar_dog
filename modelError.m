function msErr = modelError(newParams, rgcTable,modelParams)

%% Unpack optimization parameters and set constraints
CSR = newParams(1);
sSize = newParams(2);

% if sSize <= 50
%     msErr = 100;
%     return
% elseif sSize > 1200
%     msErr = 100;
%     return
% elseif CSR < .5
%     msErr = 100;
%     return
% elseif CSR > 5
%     msErr = 100;
%     return
% end

%% overwrite the model parameters with our new optimized parameters
modelParams.CSR = CSR;
modelParams.sSize = sSize;

%% run the model
modelOut = calcRgcResp(modelParams, rgcTable);

%% mean squared error
msErr = mean(modelOut.respErr); 
end