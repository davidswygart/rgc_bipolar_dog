load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\measuredONalpha.mat');
load('C:\Users\david\Documents\Code\Github\rgc_bipolar_dog\measuredPixON.mat');

%[pixFits,pfPixCV,pfAlphCV] = fitAndCrossVal(measuredPixON,measuredONalpha);
[alphFits,afAlphCV,afPixCV] = fitAndCrossVal(measuredONalpha,measuredPixON);