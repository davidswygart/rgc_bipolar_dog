%load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\measuredONalpha.mat');
%load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\measuredPixON.mat');
%load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\tableUpdate.mat')


%[pixFits,pfCV] = fitAndCrossVal(measuredPixON,measuredONalpha,modelParams);
%[alphFits,afCV] = fitAndCrossVal(measuredONalpha,measuredPixON,modelParams);
load('C:\Users\dis006\Documents\GitHub\rgc_bipolar_dog\data\DataAndFits.mat');

%% fitting a bipolar cell

f = modelParams;
f.sSize = 100;
f.CSR = 1;
[bpFits,~] = fitAndCrossVal(bipolar,measuredPixON,f);

f.sSize = mean(bpFits.sSize);
f.CSR = mean(bpFits.CSR);
modelOut = calcRgcResp(f, bipolar, 'plot');
% needed to change starting parameters but fit to
%% bipolar shape for alpha fit
f = modelParams;
f.sSize = mean(alphFits.sSize);
f.CSR = mean(alphFits.CSR);
modelOut = calcRgcResp(f, bipolar, 'plot');

%% bipolar shape for pix fit
f = modelParams;
f.sSize = mean(pixFits.sSize);
f.CSR = mean(pixFits.CSR);
modelOut = calcRgcResp(f, bipolar, 'plot');
%% for plotting

load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\DataAndFits.mat');
f = modelParams;
f.sSize = mean(alphFits.sSize);
f.CSR = mean(alphFits.CSR);
modelOut = calcRgcResp(f, measuredONalpha, 'plot');

%% checking if 50% drop in surround allows alpha lack of suppression
f = modelParams;
f.sSize = mean(pixFits.sSize);
f.CSR = mean(pixFits.CSR)/.75;
modelOut = calcRgcResp(f, measuredONalpha, 'plot');
sprintf('avg model suppression = %g', mean(modelOut.modelSS))
sprintf('avg real suppression = %g', mean(measuredONalpha.measuredSS))



%% Normalize Surround size by 100 um
f = modelParams;
f.sSize = 1;
f.CSR = 1;
[bpFits,~] = fit_BalanceBothRGCs(bipolar,measuredPixON,f);






