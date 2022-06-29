function msErr = modelRgcSms(param, sampleLoc, spotSizes, resp)
%sSize = param(1);
CSR = param(1);
sSize = 127;

if sSize < 45
    msErr = 100;
    return
elseif sSize > 2000
    msErr = 100;
    return
elseif CSR < .2
    msErr = 100;
    return
elseif CSR > 20
    msErr = 100;
    return
end



%% make bipolar DoG
cSize = 43; % 2 SD center
res = 5; % resolution (um/pixel)

% Bipolar DoG
[bipolarDog] = genBipolarFilter(cSize, CSR, sSize, res);

%% create image of bipolar input based on sample synapses
rgcDog = genRgcDog(sampleLoc,bipolarDog,res);

%% Run spots multi size on RGC
modelResp = smsExperiment(rgcDog, res, spotSizes);

%% compare to resp
msErr = mean((resp-modelResp).^2);
end