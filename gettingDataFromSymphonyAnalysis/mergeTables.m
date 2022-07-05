output = table(sms(:,1),sms(:,2), [sms{:,3}]','VariableNames', ["spotSizes","realResp","measuredSS"]);
measuredPixON = [measuredPixON output];
