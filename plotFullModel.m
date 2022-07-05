function modelRgcResp = plotFullModel(dataTable,cSize,sSize,CSR,res)
spotSizes = dataTable.spotSizes{1};
realResp = dataTable.realResp{1};


%% Bipolar DoG
figure(11)
[bipolarDog] = genBipolarFilter(cSize, CSR, sSize, res,'plot');

% Spots Multi Size response for Bipolar
figure(12)
smsExperiment(bipolarDog, res, spotSizes,'plot');
title('Spots multi-size response of bipolar cell')

%% create image of bipolar input based on sample synapses
figure(13)
rgcDog = genRgcDog(dataTable.randSyn{1}, bipolarDog,res,'plot');

%% Run spots multi size on RGC
figure(14)
modelRgcResp = smsExperiment(rgcDog, res, spotSizes,'plot');
title('Spots multi-size response of RGC')
hold on
plot(spotSizes,realResp)

legend('model','experimental')

%calculate error
MSE = mean((realResp-modelRgcResp).^2);
text(800,0.85,['MSE = ' num2str(round(MSE,3))])


%calculate Supression
SS = 100*(1-modelRgcResp(end)/max(modelRgcResp));
text(800,0.75,['SS = ' num2str(round(SS))])

hold off

modelRgcResp = reshape(modelRgcResp,[],1);
end
