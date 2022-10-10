function analyzeCrossVal(rgcs, fits)

nPerms = size(fits,1);




spotSizes = rgcs.spotSizes{1};


ssErr = nan(size(rgcs,1), nPerms);
err = nan(size(rgcs,1), nPerms);
resps = nan(size(rgcs,1), length(spotSizes), nPerms);

for i=1:nPerms
    cv = fits.crossVal{i};
    err(:,i) = cv.MAE;
    ssErr(:,i) = cv.SsErr;
    resps(:,:,i) = cell2mat(cv.modelResp);
end

%resps = permute(resps, [1,3,2]);
%resps = 
resps = mean(resps,3);

%%
hold on
for i=9:22
    %hold off
    %plot(spotSizes,resps(i,:))
    %hold on
    %plot(spotSizes, rgcs.realResp{i})

    d = rgcs.realResp{i} - resps(i,:);
    plot(spotSizes, d)
    
end
hold off
%%
cvInds = ~cell2mat(fits.fitInds');

cvSsErr = nan(size(ssErr));
cvSsErr(cvInds) = ssErr(cvInds);
mcvErr = mean(cvSsErr,2,'omitnan');


cvErr = nan(size(err));
cvErr(cvInds) = err(cvInds);
mErr = mean(cvErr,2,'omitnan');
%%
%histogram(mcvErr,12)
histogram(mErr,12)

end