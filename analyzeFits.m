function [fitRGCs, cvRGCs] = analyzeFits(fits)
% median bipolar CSR and Surround
% bipolar RF (example or average?)
% RGC model response (single RGC or all fit?), Single model fit or average?
% return average response and error for fit RGCs and cross val RGCs
%%
sprintf('CSR = %g +- %g (med +- mad)', median(fits.CSR), mad(fits.CSR,1))
sprintf('sSize = %g +- %g (med +- mad)', median(fits.sSize), mad(fits.sSize,1))

%% unpack all fit values into a bunch of matrixes
cv = fits.crossVal{1};

numRGCs = size(cv,1);
nPerms = size(fits,1);
nSpots = length(cv.resp{1});

resps = nan(numRGCs, nPerms, nSpots);
mae = nan(numRGCs, nPerms);
sup = nan(numRGCs, nPerms);
supErr = nan(numRGCs, nPerms);
fitInds = nan(numRGCs, nPerms);


for p = 1:nPerms
    fitInds(:, p) = fits.fitInds{p};
    cv = fits.crossVal{p};
    for r = 1:numRGCs
        resps(r,p,:) = cv.resp{r};
        mae(r,p) = cv.MAE(r);
        sup(r,p) = cv.sup(r);
        supErr(r,p) = cv.supErr(r);
        
    end
end
fitInds = logical(fitInds);
%% Pack the matrixes back into RGC tables after splitting by fit vs. cross-validation RGCs
fitRGCs = cv;
cvRGCs = cv;

for r = 1:numRGCs
    if any(fitInds(r,:))
        fitRGCs.MAE(r) = mean(mae(r, fitInds(r,:)));
        fitRGCs.sup(r) = mean(sup(r, fitInds(r,:)));
        fitRGCs.supErr(r) = mean(supErr(r, fitInds(r,:)));
        fitRGCs.resp(r) = {squeeze(mean(resps(r, fitInds(r,:),:),2))};
    end
    
    cvRGCs.MAE(r) = mean(mae(r, ~fitInds(r,:)));
    cvRGCs.sup(r) = mean(sup(r, ~fitInds(r,:)));
    cvRGCs.supErr(r) = mean(supErr(r, ~fitInds(r,:)));
    cvRGCs.resp(r) = {squeeze(mean(resps(r, ~fitInds(r,:),:),2))};
end
% 
% cvMEA = nan(22,1);
% cvSup = nan(22,1);
% 
% 
% for i=1:size(cv,1)
% %     figure(1)
% %     clf
% %     hold on
% %     plot(rgcs.spotSizes{i},rgcs.realResp{i})
% %     plot(rgcs.spotSizes{i}, mean(cvRGCs.resp{i},1))
% %     if ~isempty(fitRGCs.resp{i})
% %         plot(rgcs.spotSizes{i}, mean(fitRGCs.resp{i},1))
% %     end
% %     legend('real', 'cv', 'fit') 
%     cvMEA(i) = mean(cvRGCs.MAE{i});
%     cvSup(i) = mean(cvRGCs.sup{i});
end