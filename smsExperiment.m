function resp = smsExperiment(dog, distImg, spotSizes)

    resp = zeros(size(spotSizes));

        for i = 2:length(spotSizes)
           resp(i) = sum(dog(distImg < spotSizes(i)/2));
        end
    
    resp = resp/max(resp);
end