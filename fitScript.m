%load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\measuredONalpha.mat');
%load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\measuredPixON.mat');
%load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\tableUpdate.mat')


%[pixFits,pfCV] = fitAndCrossVal(measuredPixON,measuredONalpha,modelParams);
%[alphFits,afCV] = fitAndCrossVal(measuredONalpha,measuredPixON,modelParams);
load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\DataAndFits_2.mat');

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

load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\data\DataAndFits_2.mat');
f = modelParams;
f.sSize = mean(alphFits.sSize);
f.CSR = mean(alphFits.CSR);
modelOut = calcRgcResp(f, measuredONalpha, 'plot');


