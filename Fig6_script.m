load data/realRgcs.mat
load data/neuronCSR.mat
pixONs = rgcs(rgcs.type == 'Pix ON', :);
onAlphas = rgcs(rgcs.type == 'ON alpha', :);

%% Set model parameters

% precomputed a 1200 um wide distance image (largest spot size)
res = 5;
[x,y] = ndgrid(-600 : res : 600);
modelParams.distImage = sqrt(x.^2 + y.^2);

% set surround size as fit to Pix (will be held constant)
modelParams.sSize = 75.0001;

%%%%%%%%%%%%%%%%%%%%%%%%%%% Bipolar RF examples %%%%%%%%%%%%%%%%%%%%%%%%


 %%%%%%%%%%%%%%%%%%%%%%%% Active model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate for n=1
predictedPixN1  = predictedSuppression(pixONs, neuronCSR_active.n1_q1, modelParams);
predictedAlphaN1 =  predictedSuppression(onAlphas, neuronCSR_active.n1_q4, modelParams);
plotScatter(predictedPixN1,predictedAlphaN1,pixONs,onAlphas)

%% Calculate for n=60
predictedPixN60  = predictedSuppression(pixONs, neuronCSR_active.n60q1, modelParams);
predictedAlphaN60 =  predictedSuppression(onAlphas, neuronCSR_active.n60q4, modelParams);
plotScatter(predictedPixN60,predictedAlphaN60,pixONs,onAlphas)

%% Calculate for n=120
predictedPixN120  = predictedSuppression(pixONs, neuronCSR_active.n120q1, modelParams);
predictedAlphaN120 =  predictedSuppression(onAlphas, neuronCSR_active.n120q4, modelParams);
plotScatter(predictedPixN120,predictedAlphaN120,pixONs,onAlphas)

 %%%%%%%%%%%%%%%%%%%%%%%% Passive model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate for n=1
predictedPixN1  = predictedSuppression(pixONs, neuronCSR_passive.n1_q1, modelParams);
predictedAlphaN1 =  predictedSuppression(onAlphas, neuronCSR_passive.n1_q4, modelParams);
plotScatter(predictedPixN1,predictedAlphaN1,pixONs,onAlphas)

%% Calculate for n=60
predictedPixN60  = predictedSuppression(pixONs, neuronCSR_passive.n60q1, modelParams);
predictedAlphaN60 =  predictedSuppression(onAlphas, neuronCSR_passive.n60q4, modelParams);
plotScatter(predictedPixN60,predictedAlphaN60,pixONs,onAlphas)

%% Calculate for n=120
predictedPixN120  = predictedSuppression(pixONs, neuronCSR_passive.n120q1, modelParams);
predictedAlphaN120 =  predictedSuppression(onAlphas, neuronCSR_passive.n120q4, modelParams);
plotScatter(predictedPixN120,predictedAlphaN120,pixONs,onAlphas)


%% Bipolar RF example
CSR_pixON = 1.075;
CSR_onAlpha = 2.2688;

microns = -500:500;
z = zeros(length(microns), length(microns));
z(500,500) = 1;


cImg = imgaussfilt(z, 22, "FilterSize", 1001);
sImg = imgaussfilt(z, 75, "FilterSize", 1001);

pixDog = CSR_pixON * cImg - sImg;
alphaDog = CSR_onAlpha * cImg - sImg;


pixDog_2d = sum(pixDog);
pixDog_2d = pixDog_2d / max(pixDog_2d);
pixDog_2d(isnan(pixDog_2d) | pixDog_2d == inf | pixDog_2d == -inf) = 0;

alphaDog_2d = sum(alphaDog);
alphaDog_2d = alphaDog_2d / max(alphaDog_2d);
alphaDog_2d(isnan(alphaDog_2d) | alphaDog_2d == inf | alphaDog_2d == -inf) = 0;



figure(3)
clf
subplot(2,1,1)
plot(microns, pixDog_2d)
title('pixON')

subplot(2,1,2)
plot(microns, alphaDog_2d)
title('ON alpha')
xlabel('microns')

%% RGC prediction example
modelParams.CSR = CSR_pixON;
t = calcRgcResp(pixONs, modelParams,  'no plot');
pixSMS = mean(cell2mat(t.resp))';

modelParams.CSR = CSR_onAlpha;
t = calcRgcResp(onAlphas, modelParams,  'no plot');
alphaSMS = mean(cell2mat(t.resp))';


figure(4)
subplot(2,1,1)
plot(rgcs.spotSizes{1},pixSMS)
title('PixON prediction')

subplot(2,1,2)
plot(rgcs.spotSizes{1}, alphaSMS)
title('ON alpha prediction')
xlabel('spotSizes')
ylabel('excitation (norm.)')


%% functions
function predicted = predictedSuppression(rgcs, csrVals, modelParams)
    predicted = nan(length(csrVals),1);

    for i=1:length(csrVals)
        modelParams.CSR = csrVals(i);
        t = calcRgcResp(rgcs, modelParams,  'no plot');
        predicted(i) = mean(t.sup);
    end    
end

function plotScatter(predictedPix, predictedAlpha, realPix, realAlpha)
    clf
    scatter(predictedPix, predictedAlpha, 'filled')
    xlim([0,100])
    ylim([0,100])
    hold on
    scatter([mean(realPix.measuredSS)], [mean(realAlpha.measuredSS)], 2000,'+')
    
    xlabel('Predicted PixON suppression')
    ylabel('Predicted ON alpha supppression')
    hold off
end

