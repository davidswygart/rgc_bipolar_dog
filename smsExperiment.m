function resp = smsExperiment(dog, res, spotSizesUm, plotOp)
% minSpot = 30;
% maxSpot = 1200;
% numSpots = 50;
% spotSizesUm = logspace(log(minSpot)/log(10), log(maxSpot)/log(10), numSpots);

szFiltInd = size(dog,1);
filtCenterInd = ceil(szFiltInd/2);
[yInd, xInd]= ndgrid(1:szFiltInd,1:szFiltInd);
xUm = (xInd - filtCenterInd)*res;
yUm = (yInd - filtCenterInd)*res;
cenDistUm = sqrt((yUm).^2 + (xUm).^2);


resp = nan(size(spotSizesUm));
for i = 1:length(spotSizesUm)
   spot = cenDistUm <= spotSizesUm(i)/2;
   temp = dog;
   temp(~spot) = 0;
   resp(i) = sum(temp(:));  
end

resp = resp/max(resp);

if strcmp(plotOp, 'plot')
    plot(spotSizesUm,resp)
    xlabel('Spot diameter (um)')
end

end