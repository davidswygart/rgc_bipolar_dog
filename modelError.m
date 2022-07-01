function msErr = modelError(param, sampleLoc, spotSizes, resp,cSize,res)

%% Unpack optimization parameters and set constraints
CSR = param(1);
sSize = param(2);

if sSize <= cSize
    msErr = 1+cSize-sSize;
    return
elseif sSize > 1200
    msErr = 1+sSize;
    return
elseif CSR < .5
    msErr = 1+(1/CSR);
    return
elseif CSR > 5
    msErr = 1+CSR;
    return
end

%% make bipolar DoG
[bipolarDog] = genBipolarFilter(cSize, CSR, sSize, res, 'no plot');

%% create image of bipolar input based on sample synapses
rgcDog = genRgcDog(sampleLoc,bipolarDog,res,'no plot');

%% Run spots multi size on RGC
modelResp = smsExperiment(rgcDog, res, spotSizes, 'no plot');

%% compare to resp
msErr = mean((resp-modelResp).^2); 
end