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
    clf
    hold on
    for i = 1:size(curLoc)
        plot([curLoc(i,1), parentLoc(i,1)], [curLoc(i,2), parentLoc(i,2)], 'k', 'LineWidth',1.5)
    end
    lim = 200;
    surf([-lim,lim;-lim,lim],[lim,lim;-lim,-lim],[-1,-1;-1,-1])
    zlim([-10,10])
    
    
    scatter(sampleLoc(:,1),sampleLoc(:,2),'*','b')
    scatter(0,0, 500,'+','r')
    hold off
    title('2D projection and sample synapse locations')
    xlabel('um')
end

%% need integrated, make image of random sample for faster computation
 tempImg = zeros(241);%241 pixels, 5 um/pix, center = 121
% tempImg(121,121) = 1;
% centerImg = imgaussfilt(tempImg,121/2/5);
% plot(-600:5:601, centerImg(121,:))
% xlim([0 100])



table = measuredONalpha;
%table = measuredPixON;
 
 for i=1:size(table,1)
     syn = table.randSyn{i};
     syn = round(syn/5)+121;
     
     newTemp = tempImg;
     for ii = 1:size(syn,1)
         newTemp(syn(ii,1), syn(ii,2)) = newTemp(syn(ii,1), syn(ii,2)) + 1;
     end
     table.randSyn{i} = newTemp;
     
     
     
 end


end