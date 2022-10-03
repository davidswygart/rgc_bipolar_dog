% function crossVal(fullFit){
% modelParams - fullFit.modelParams;
% 
% for i=1:size(fullFit.fits,1)
% end
% 
% % calcRgcResp(modelParams, rgcTable, plotOp)
% % 
% %         for r = 1:nTrain
% %             fit1.randSyn{r} = getRandSyns(fit1.trace{r}, modelParams.resolution);
% %             fit2.randSyn{r} = getRandSyns(fit2.trace{r}, modelParams.resolution);
% %             fit1.cImg{r} = imgaussfilt(fit1.randSyn{r}, sigma, 'FilterSize', filtSize);
% %             fit2.cImg{r} = imgaussfilt(fit2.randSyn{r}, sigma, 'FilterSize', filtSize);
% %         end
% }
% 

%out = balancedFit(measuredPixON,measuredOnAlpha,100);
pFits = balancedFit(measuredPixON,measuredPixON,100);
aFits = balancedFit(measuredOnAlpha,measuredOnAlpha,100);
% 
%  for i=1:size(measuredOnAlpha,1)
%      ss = measuredOnAlpha.spotSizes{i}';
%      rr = measuredOnAlpha.realResp{i}';
%      plot(ss,rr)
% 
%      newX = (0:80:1200)';
%      newY = interp1(ss,rr,newX);
% 
%      hold on
%      plot(newX,newY)
%      hold off
%  end
% 
% 
%  for i=1:size(measuredPixON,1)
%      ss = measuredPixON.spotSizes{i}';
%      rr = measuredPixON.realResp{i}';
%      plot(ss,rr)
% 
%      newX = (0:80:1200)';
%      newY = interp1(ss,rr,newX);
% 
%      hold on
%      plot(newX,newY)
%      hold off
%  end