load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\PixFits.mat')
load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\alphFits.mat')
load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\measuredONalpha.mat')
load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\measuredPixON.mat')


%% plot fit values
figure(100)
subplot(2,2,1)
histogram(pixFits.sSize,20)
title('PixON fits to surround size')
xlim([100,400])

subplot(2,2,2)
histogram(pixFits.CSR,20)
title('PixON fits to CSR')
xlim([1,2.8])

subplot(2,2,3)
histogram(alphFits.sSize,10)
title('alpha fits to surround size')
xlim([100,400])

subplot(2,2,4)
histogram(alphFits.CSR,10)
title('alpha fits to CSR')
xlim([1,2.8])

avgPixFit = array2table(mean(pixFits{:,:}), 'VariableNames',pixFits.Properties.VariableNames);
stdPixFit = array2table(std(pixFits{:,:}), 'VariableNames',pixFits.Properties.VariableNames);
avgAlphFit = array2table(mean(alphFits{:,:}), 'VariableNames',alphFits.Properties.VariableNames);
stdAlphFit = array2table(std(alphFits{:,:}), 'VariableNames',alphFits.Properties.VariableNames);



display(['Pix surround = ' num2str(avgPixFit.sSize) ' +- ' num2str(stdPixFit.sSize)])
display(['Pix CSR = ' num2str(avgPixFit.CSR) ' +- ' num2str(stdPixFit.CSR)])
display(['alpha surround = ' num2str(avgAlphFit.sSize) ' +- ' num2str(stdAlphFit.sSize)])
display(['alpha CSR = ' num2str(avgAlphFit.CSR) ' +- ' num2str(stdAlphFit.CSR)])

%% get real SMS
spotSizes = measuredPixON.spotSizes{1};

r = reshape([measuredPixON.realResp{:}], length(spotSizes), [])';
avgPixResp = mean(r,1);
semPixResp = std(r) / sqrt(length(measuredPixON.cellName));

r = reshape([measuredONalpha.realResp{:}], length(spotSizes), [])';
avgAlphaResp = mean(r,1);
semAlphaResp = std(r) / sqrt(length(measuredONalpha.cellName));


figure(101)
subplot(1,2,1)
errorbar(spotSizes,avgPixResp,semPixResp)
title('PixON')
subplot(1,2,2)
errorbar(spotSizes,avgAlphaResp,semAlphaResp)
%% get model SMS from avg fit values
tic
modelOut = calcRgcResp2(avgPixFit(1,1:4),measuredPixON, 'no plot');
toc
r = reshape([modelOut.modelResp{:}], length(spotSizes), [])';
avgPixModel = mean(r,1);
semPixModel = std(r) / sqrt(length(measuredPixON.cellName));
%%
modelOut = calcRgcResp(avgAlphFit(1,1:4),measuredONalpha, 'plot');
r = reshape([modelOut.modelResp{:}], length(spotSizes), [])';
avgAlphaModel = mean(r,1);
semAlphaModel = std(r) / sqrt(length(measuredONalpha.cellName));

figure(101)
subplot(1,2,1)
hold on
errorbar(spotSizes,avgPixModel,semPixModel)
hold off
subplot(1,2,2)
hold on
errorbar(spotSizes,avgAlphaModel,semAlphaModel)
hold off

%% plot SS of model and real
modelOut = calcRgcResp(avgPixFit(1,1:4),measuredPixON);
pixPixModelSS = modelOut.modelSS;
modelOut = calcRgcResp(avgPixFit(1,1:4),measuredONalpha);
pixAlphModelSS = modelOut.modelSS;
modelOut = calcRgcResp(avgAlphFit(1,1:4),measuredONalpha);
alphAlphModelSS = modelOut.modelSS;
modelOut = calcRgcResp(avgAlphFit(1,1:4),measuredPixON);
alphPixModelSS = modelOut.modelSS;
%% 
% figure(102)
% subplot(1,2,1)
% scatter(measuredPixON.measuredSS,pixAlphModelSS)
% subplot(1,2,2)
% scatter(measuredONalpha.measuredSS,alphSsModel)

%% get ss error for cross validation

 pixPix = [pfPixCV.ModelSs{:}] - [pfPixCV.RealSs{:}];
 avgPixPix = mean(pixPix(:))
 stdPixPix = std(pixPix(:))
 
 pixAlph = [pfAlphCV.ModelSs{:}] - [pfAlphCV.RealSs{:}];
 avgPixAlph = mean(pixAlph(:))
 stdPixAlph = std(pixAlph(:))
 
 alphPix = [afPixCV.ModelSs{:}] - [afPixCV.RealSs{:}];
 avgAlphPix = mean(alphPix(:))
 stdAlphPix = std(alphPix(:))
 
 alphAlph = [afAlphCV.ModelSs{:}] - [afAlphCV.RealSs{:}];
 avgAlphAlph = mean(alphAlph(:))
 stdAlphAlph = std(alphAlph(:))
 
 
 %%
 
 

 
 