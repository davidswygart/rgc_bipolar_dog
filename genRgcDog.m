function rgcDog = genRgcDog(synLoc,bipolarDog,res, plotOp)

%% determine the size necessary for the RGC dog image
bipolarSz = size(bipolarDog,1);
maxNodeUm = max(abs(synLoc(:))); % maximum distance from center (um)
rgcDogSzInd = ceil((maxNodeUm*2)/res) + bipolarSz + 10; %size of image in index units (add half a filter on each side for padding)
if ~mod(rgcDogSzInd,2) %if even, make odd
    rgcDogSzInd = rgcDogSzInd + 1;
end
rgcDog = zeros(rgcDogSzInd);

%% shift the synapse locations to pixel coordinates
rgcCenterInd = ceil(rgcDogSzInd/2);
bipolarCenterInd = ceil(bipolarSz/2);

synLocInd = round(synLoc / res); %Convert synapse location to pixel index
synLocInd = synLocInd(:,1:2); %Only use X,Y
synLocInd = synLocInd + rgcCenterInd; %add back the center so index starts at 1
synLocInd = synLocInd - bipolarCenterInd; %Move so that indexed by upper corner of filter

 %% add together bipolar DoGs at synapse locations
 
for i=1:size(synLocInd,1)
    startX = synLocInd(i,1);
    startY = synLocInd(i,2);
    endX = startX + bipolarSz - 1;
    endY = startY + bipolarSz - 1;
    
    rgcDog(startY:endY,startX:endX) = rgcDog(startY:endY,startX:endX) + bipolarDog;
end
rgcDog = rgcDog / max(rgcDog(:));

if strcmp(plotOp, 'plot')
    figure(106)
    hold off
    title('bipolar activation')
    s = rgcCenterInd*res;
    imagesc([-s,s],[-s,s],rgcDog)
    %imagesc(bipolarExc)

    colorbar
    hold on
    scatter(synLoc(:,1),synLoc(:,2),'.','k')
    hold off
    xlabel('um')
end
end