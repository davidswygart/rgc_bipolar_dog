cSize = 43; % 2 SD center
sSize = 90; % 2 SD surround
CSR = .8; % center / surround
res = 1; % resolution (um/pixel)

[dog] = genBipolarFilter(cSize, CSR, sSize, res);





%% Spots Multi Size response for Bipolar
spotSizesUm = linspace(res*2,1000,50);
resp = nan(size(spotSizesUm));
for i = 1:length(spotSizesUm)
   spot = cDistUm <= spotSizesUm(i)/2;
   temp = dog;
   temp(~spot) = 0;
   resp(i) = sum(temp(:));  
end

figure(4)
plot(spotSizesUm,resp)
xlabel('Spot diameter (um)')
title('Spots multi-size response of bipolar cell')

%% import trace and choose sample synapse locations
[trace, parentNode]= importTrace('trace.swc');

trace = trace - mean(trace,1);%center the nodes at the centroid

figure(5)
clf
scatter3(trace(:,1),trace(:,2),trace(:,3),'.')
title('3D trace')
xlabel('um')

curLoc = trace(2:end,:);
parentLoc = trace(parentNode(2:end),:);

xyDist = sqrt((curLoc(:,1) - parentLoc(:,1)).^2 + (curLoc(:,2)-parentLoc(:,2)).^2); %+ (curLoc(:,3) - parentLoc(:,3)).^2);
totalDendDist = sum(xyDist);


synPerMicron = 0.2;
numSyns = round(totalDendDist*synPerMicron);
sampleInds = randsample(size(trace,1),numSyns);
sampleLocUm = trace(sampleInds,:);




figure(6)
scatter(trace(:,1),trace(:,2),'.','k')
hold on
scatter(sampleLocUm(:,1),sampleLocUm(:,2),'*','b')
scatter(0,0, 500,'+','r')
hold off
title('2D projection and sample synapse locations')
xlabel('um')

%% create image of bipolar input
maxNodeUm = max(abs(trace(:))); % maximum distance from center
imgSizeInd = ceil((maxNodeUm*2)/res) + szFiltInd; %size of image in index units (add half a filter for padding)
imgCenterInd = round(imgSizeInd/2);
halfImgUm = imgCenterInd*res;

[yInd, xInd]= ndgrid(1:imgSizeInd,1:imgSizeInd);
xUm = (xInd - imgCenterInd)*res;
yUm = (yInd - imgCenterInd)*res;
centerDistUmRGC = sqrt((yUm).^2 + (xUm).^2);

sampleLocInd = round(sampleLocUm / res); %Convert synapse location to index
sampleLocInd = sampleLocInd(:,1:2); %Only use X,Y
sampleLocInd = sampleLocInd + imgCenterInd; %add back the center so index starts at 1
sampleLocInd = sampleLocInd - filtCenterInd; %Move so that indexed by upper corner of filter 

bipolarExc = zeros(size(centerDistUmRGC));

for i=1:size(sampleLocInd,1)
    startX = sampleLocInd(i,1);
    startY = sampleLocInd(i,2);
    endX = startX + szFiltInd - 1;
    endY = startY + szFiltInd - 1;
    
    bipolarExc(startY:endY,startX:endX) = bipolarExc(startY:endY,startX:endX) + dog;
end
bipolarExc = bipolarExc / sum(bipolarExc(:));

figure(7)
title('bipolar activation')
imagesc(xUm(1,:),yUm(:,1),bipolarExc)
%imagesc(bipolarExc)
xlabel('um')
colorbar

hold on
scatter(sampleLocUm(:,1),sampleLocUm(:,2),'.','b')
hold off

%% Run spots multi size on RGC
spotSizesUm = linspace(30,1400,50);
resp = nan(size(spotSizesUm));
for i = 1:length(spotSizesUm)
   spot = centerDistUmRGC <= spotSizesUm(i)/2;
   temp = bipolarExc;
   temp(~spot) = 0;
   resp(i) = sum(temp(:));  
end

figure(8)
plot(spotSizesUm,resp)
xlabel('Spot diameter (um)')
title('Spots multi-size response of RGC')
