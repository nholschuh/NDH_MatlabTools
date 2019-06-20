function [values,position] = neighborhood(x,y,coord,points,crossv,anisotropy)

% searches the neighborhood of the point (x,y) for the nearest 
% 'points' number of points and calculates the lag and the relative
% coordinates.
%
% usage:    [values,position] = neighborhood(x,y,coord,points,crossv,anisotropy)

% 16.6.2003 Rolf Sidler

dist = sqrt(((coord(:,1)-x)/anisotropy).^2+(coord(:,2)-y).^2);
%dist = sqrt(((coord(:,1)-x)).^2+(coord(:,2)-y).^2); %(non anisotropic search neighborhood)
[lags,index] = sort(dist);
index = index(1:points);
values = coord(index,3)';
position(:,1) = coord(index,1)-x;
position(:,2) = coord(index,2)-y;

% deleteing first point for crossvaidation
if crossv
values = values(2:end);
position = position(2:end,:);
end
