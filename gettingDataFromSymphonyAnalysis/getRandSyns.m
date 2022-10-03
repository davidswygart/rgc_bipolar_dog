function img = getRandSyns(trace,resolution)
    synPerMicron = 0.3;
    
    trace3D = trace.trace;
    
    %% get random sampling of synapses
    numSyns = round(trace.totalLength * synPerMicron);
    sampleInds = randsample(size(trace3D,1),numSyns);
    sampleLoc = trace3D(sampleInds,:);
    sampleLoc = sampleLoc(:,1:2); %get rid of Z
    
    %% make a 1200 um Image of the random synapses
    npix = round(1200/resolution)+1;
    img = zeros(npix,npix);
    
    sampleLoc = round((sampleLoc + 600) / resolution);
    for i=1:size(sampleLoc,1)
        x = sampleLoc(i,1);
        y = sampleLoc(i,2);
        img(x,y) = img(x,y) + 1;
    end
end