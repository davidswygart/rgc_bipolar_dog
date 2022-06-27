function [dog] = genBipolarFilter(cSize, CSR, sSize, res)

cSize = cSize/2;
sSize = sSize/2;

szFiltInd = ceil(sSize*8/res); % make the filter 8x standard Dev
if ~mod(szFiltInd,2) %if even, make odd
    szFiltInd = szFiltInd + 1;
end
filtCenterInd = ceil(szFiltInd/2);

[yInd, xInd]= ndgrid(1:szFiltInd,1:szFiltInd);
xUm = (xInd - filtCenterInd)*res;
yUm = (yInd - filtCenterInd)*res;
% cenDistUm = sqrt((yUm).^2 + (xUm).^2);

center = fspecial('gaussian', [szFiltInd szFiltInd], cSize/res)*res;
surround = fspecial('gaussian', [szFiltInd szFiltInd], sSize/res)*res;
dog = CSR*center-surround;

figure(1)
% surf(xUm,yUm,center)

x = xUm(1,:);
hold off
plot(x,center(filtCenterInd,:), 'b')
hold on
plot(x,surround(filtCenterInd,:), 'r')
plot(x,dog(filtCenterInd,:), 'k')
xlabel('distance from center (um)')
title('bipolar center/surround')
legend('center','surround','DoG')
end