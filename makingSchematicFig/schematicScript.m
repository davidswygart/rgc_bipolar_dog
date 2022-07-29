%load('matlab.mat')

figure(999)
clf
hold on
view([60 13])

%% make a grey background box
zoff = .1;
greyLim = 250;
greyX = [-greyLim,greyLim;-greyLim,greyLim];
greyY = [greyLim,greyLim;-greyLim,-greyLim];
greyColor = repmat([.5,.5,.5]', 1,size(greyX,1),size(greyX,2));
greyColor = permute(greyColor,[2,3,1]);

zmult = 2;
% plot grey boxes (z = 0,1,2,3)
for z = -1:1
    zn = zeros(size(greyX))+z*zmult;
    surf(greyX,greyY,zn,greyColor)
end



%% plot RGC dendrites
zlevel = 0*zmult + zoff;

for i = 1:size(traceImg.curLoc)
    plot3([traceImg.curLoc(i,1), traceImg.parentLoc(i,1)], ...
        [traceImg.curLoc(i,2), traceImg.parentLoc(i,2)], [zlevel,zlevel], 'k', 'LineWidth',1.5)
end

synInd = 4434; %very far right
scatter3(traceImg.parentLoc(synInd,1),traceImg.parentLoc(synInd,2),zlevel,'*','r')
%scatter3(traceImg.parentLoc(synInd,1),traceImg.parentLoc(synInd,2),zlevel,1.5,'.','r')
%110.7 -27.7
%% plot bipolar RF
zlevel = 1*zmult + zoff;

lim = round(size(bDog.x,1)*.5/2);
limInd = bDog.center-lim:bDog.center+lim;
x = bDog.x(limInd,limInd);
y = bDog.y(limInd,limInd);
x = x + traceImg.parentLoc(synInd,1); %shift to center on synapse
y = y + traceImg.parentLoc(synInd,2);
d = bDog.vals(limInd,limInd)/2;
z = d+zlevel-min(d(:));
c = bDog.color(limInd,limInd,:);
%c = ccc(limInd,limInd,:);
surf(x,y,z,c,'FaceColor','interp','EdgeColor','none');

%% plot stimuli circle
zlevel = 2*zmult% + zoff;
r = 200;

[y,x] = ndgrid(-greyLim:5:greyLim,-greyLim:5:greyLim);
dist = sqrt((x.^2 + y.^2));
c = ones(size(x));
c(dist>r) = .5;
c = repmat(c,1,1,3);
z = zeros(size(x)) + zlevel;
surf(x,y,z,c,'EdgeColor','none')

%plot outline around gray box
x = [-greyLim,-greyLim,greyLim,greyLim,-greyLim];
y = [-greyLim,greyLim,greyLim,-greyLim,-greyLim];
z = y*0 + zlevel;
plot3(x,y,z,'k')

%% plot RGC RF
zlevel = -1*zmult + zoff;

lim = round(size(rDog.x,1)*.4/2);
limInd = rDog.center-lim:rDog.center+lim;
x = rDog.x(limInd,limInd);
y = rDog.y(limInd,limInd);
d = rDog.vals(limInd,limInd)/2;
z = d+zlevel-min(d(:));
c = rDog.color(limInd,limInd,:);

surf(x,y,z,c,'FaceColor','interp','EdgeColor','none');





xlim([-300,300])
ylim([-300,300])
zlim([-4,6])
%% plot red lines
offset = sqrt((44^2)/2);

xy = repmat([110.7+offset -27.7+offset],4,1);
xyz = cat(2, xy, [4.3;2;0;-2]);
plot3(xyz(:,1),xyz(:,2),xyz(:,3), ':', 'Color','red','LineWidth',1.5)

xy = repmat([110.7-offset -27.7-offset],4,1);
xyz = cat(2, xy, [4.3;2;0;-2]);
plot3(xyz(:,1),xyz(:,2),xyz(:,3), ':', 'Color','red','LineWidth',1.5)