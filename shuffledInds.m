function inds = shuffledInds(nRgcs, nTrain, nPerms)
    inds = zeros(nRgcs, 1);
    inds(1:nTrain) = 1;
    
    [~, shuf] = sort(rand(length(inds), nPerms));
    
    inds = logical(inds(shuf));
end