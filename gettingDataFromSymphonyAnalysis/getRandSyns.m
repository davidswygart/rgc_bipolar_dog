function [sampleLoc, trace] = getRandSyns(filename,synPerMicron,plotOp)

[trace, parentNode]= importTrace(filename);
trace = trace - mean(trace,1);%center the nodes at the centroid

% figure(5)
% clf
% scatter3(trace(:,1),trace(:,2),trace(:,3),'.')
% title('3D trace')
% xlabel('um')

%% calculate total dendritic distance
curLoc = trace(2:end,:);
parentLoc = trace(parentNode(2:end),:);

nodeDists = sqrt((curLoc(:,1) - parentLoc(:,1)).^2 + (curLoc(:,2)-parentLoc(:,2)).^2 + (curLoc(:,3) - parentLoc(:,3)).^2);
totalDendDist = sum(nodeDists);

%% get random sampling of synapses
numSyns = round(totalDendDist*synPerMicron);
sampleInds = randsample(size(trace,1),numSyns);
sampleLoc = trace(sampleInds,:);
sampleLoc = sampleLoc(:,1:2); %get rid of Z

if strcmp(plotOp, 'plot')
    hold off
    scatter(trace(:,1),trace(:,2),'.','k')
    hold on
    scatter(sampleLoc(:,1),sampleLoc(:,2),'*','b')
    scatter(0,0, 500,'+','r')
    hold off
    title('2D projection and sample synapse locations')
    xlabel('um')
end


end