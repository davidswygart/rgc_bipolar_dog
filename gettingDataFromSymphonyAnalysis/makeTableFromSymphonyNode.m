%output = table({0},{0}, [0],'VariableNames', ["spotSizes","realResp","measuredSS"]);
spotSizes = nodeData.spotSize;
realResp = nodeData.stimInterval_charge.mean_c;
realResp = realResp/min(realResp);
realResp = [0,realResp];
spotSizes = [0,spotSizes];

figure(101)
clf
plot(spotSizes,realResp)

temp = 0:60:1200;
r = interp1(spotSizes,realResp,temp,'linear','extrap'); %interpolate for even sampling of error

spotSizes = temp;

hold on
plot(spotSizes,r)
plot(spotSizes,smooth(r))
legend('real','interpolated','smoothed')
% 
% measuredSS = 100*(1-(realResp(end)/max(realResp)));
% 
% 
% sms{i,1} = {spotSizes};
% sms{i,2} = realResp;
% sms{i,3} = measuredSS;
% 
% i = i+1;