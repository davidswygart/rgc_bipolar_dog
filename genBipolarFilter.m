function [dog] = genBipolarFilter(modelParams, plotOp)
cSize = modelParams.cSize/2; %convert to 1 s.d.
sSize = modelParams.sSize/2; %convert to 1 s.d.
CSR = modelParams.CSR;
res = modelParams.res;

szFiltInd = ceil(sSize*6/res); % make the filter 6x standard Dev
if ~mod(szFiltInd,2) %if even, make odd
    szFiltInd = szFiltInd + 1;
end

center = fspecial('gaussian', [szFiltInd szFiltInd], cSize/res)*res;
surround = fspecial('gaussian', [szFiltInd szFiltInd], sSize/res)*res;
dog = CSR*center-surround;

%for surface plot
% [yInd, xInd]= ndgrid(1:szFiltInd,1:szFiltInd);
% xUm = (xInd - filtCenterInd)*res;
% yUm = (yInd - filtCenterInd)*res;
% s = surf(xUm,yUm,dog);
% s.EdgeColor = 'none';
if strcmp(plotOp, 'plot')
    figure(105)
    filtCenterInd = ceil(szFiltInd/2);
    x = ((1:szFiltInd)'-filtCenterInd)*res;
    c = sum(center,1)';
    s = sum(surround,1)';
    d = sum(dog,1)';
    clf
    hold on
    plot(x,c, 'b')
    plot(x,s, 'r')
    plot(x,d, 'k')
    xlabel('distance from center (um)')
    title('bipolar center/surround')
    xL = xlim();
    plot(xL,[0,0],'Color','black','LineStyle','--')
    legend('center','surround','DoG')
    hold off
    
end
end