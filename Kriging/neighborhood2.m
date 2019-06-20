 function [values,position] = neighborhood2(x,y,coord,points,crossv,anisotropy)

% searches the neighborhood of the point (x,y) for the nearest 
% 'points' number of points and calculates the lag and the relative
% coordinates. version 2 searches for a forth of points in each quadrant.
% for crossvalidation set crossv = 1 otherwise set cossv = 0
%
% usage:    [values,position] = neighborhood2(x,y,coord,points,crossv,anisotropy)

% 16.6.2003 Rolf Sidler


% sorting the points in 4 quadrants
offset(:,1) = x-coord(:,1);
offset(:,2) = y-coord(:,2);
ind1 = offset <= 10e-6;
ind2 = offset >= -10e-6;
try
ind(:,1) = intersect(ind1(:,1),ind2(:,1));
ind(:,2) = intersect(ind1(:,2),ind2(:,2));
end
offset(ind) = 0;
posxoffset = find(offset(:,1)>=0);
posyoffset = find(offset(:,2)>=0);
negxoffset = find(offset(:,1)<0);
negyoffset = find(offset(:,2)<0);
quadrant1 = intersect(posxoffset,posyoffset);
quadrant2 = intersect(negxoffset,posyoffset);
quadrant3 = intersect(negxoffset,negyoffset);
quadrant4 = intersect(posxoffset,negyoffset);

% if no points were found change to neighborhood
if isempty([quadrant1;quadrant2;quadrant3;quadrant4])
    [values,position] = neighborhood(x,y,coord,points,crossv,anisotropy)
end    

% variable
points = round(points/4);
start = 1; stop = 0;

% first quadrant
stock = length(quadrant1);
if stock > points
    stock = points;
end
stop = stop+stock;
[lag,index] = sort(sqrt(((x-coord(quadrant1,1))/anisotropy).^2+(y-coord(quadrant1,2)).^2));
index = quadrant1(index);
index = index(1:stock);
values(start:stop) = coord(index,3);
position(start:stop,1) = coord(index,1)-x;
position(start:stop,2) = coord(index,2)-y;
start = start+stock;

% second quadrant
stock = length(quadrant2);
if stock > points
    stock = points;
end
stop = stop+stock;
[lag,index] = sort(sqrt(((x-coord(quadrant2,1))/anisotropy).^2+(y-coord(quadrant2,2)).^2));
index = quadrant2(index);
index = index(1:stock);
values(start:stop) = coord(index,3);
position(start:stop,1) = coord(index,1)-x;
position(start:stop,2) = coord(index,2)-y;
start = start+stock;

% third quadrant
stock = length(quadrant3);
if stock > points
    stock = points;
end
stop = stop+stock;
[lag,index] = sort(sqrt(((x-coord(quadrant3,1))/anisotropy).^2+(y-coord(quadrant3,2)).^2));
index = quadrant3(index);
index = index(1:stock);
values(start:stop) = coord(index,3);
position(start:stop,1) = coord(index,1)-x;
position(start:stop,2) = coord(index,2)-y;
start = start+stock;

% forth quadrant
stock = length(quadrant4);
if stock > points
    stock = points;
end
stop = stop+stock;
[lag,index] = sort(sqrt(((x-coord(quadrant4,1))/anisotropy).^2+(y-coord(quadrant4,2)).^2));
index = quadrant4(index);
index = index(1:stock);
values(start:stop) = coord(index,3);
position(start:stop,1) = coord(index,1)-x;
position(start:stop,2) = coord(index,2)-y;
start = start+stock;

% deleteing first point for crossvaidation
if crossv
values = values(2:end);
position = position(2:end,:);
end


