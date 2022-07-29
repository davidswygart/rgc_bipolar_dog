function resp = smsExperiment(dog, distImg, spotSizes)
% minSpot = 30;
% maxSpot = 1200;
% numSpots = 50;
% spotSizesUm = logspace(log(minSpot)/log(10), log(maxSpot)/log(10), numSpots);


resp = nan(size(spotSizes));
for i = 1:length(spotSizes)
   spot = distImg <= spotSizes(i)/2;
   temp = dog;
   temp(~spot) = 0;
   resp(i) = sum(temp(:));  
end

resp = resp/max(resp);



end