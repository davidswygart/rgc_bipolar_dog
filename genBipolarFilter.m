function [dog] = genBipolarFilter(cSize, CSR, sSize, res)
cSize = cSize/2;
sSize = sSize/2;

szFiltInd = ceil(sSize*6/res); % make the filter 6x standard Dev
if ~mod(szFiltInd,2) %if even, make odd
    szFiltInd = szFiltInd + 1;
end

center = fspecial('gaussian', [szFiltInd szFiltInd], cSize/res)*res;
surround = fspecial('gaussian', [szFiltInd szFiltInd], sSize/res)*res;
dog = CSR*center-surround;

% [yInd, xInd]= ndgrid(1:szFiltInd,1:szFiltInd);
% xUm = (xInd - filtCenterInd)*res;
% yUm = (yInd - filtCenterInd)*res;
% cenDistUm = sqrt((yUm).^2 + (xUm).^2);
% surf(xUm,yUm,center)


filtCenterInd = ceil(szFiltInd/2);
x = (1:filtCenterInd)*res;
hold off
plot(x,center(filtCenterInd,filtCenterInd:end), 'b')
hold on
plot(x,surround(filtCenterInd,filtCenterInd:end), 'r')
plot(x,dog(filtCenterInd,filtCenterInd:end), 'k')
xlabel('distance from center (um)')
title('bipolar center/surround')
legend('center','surround','DoG')
end