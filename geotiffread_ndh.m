function [x y z] = geotiffread_ndh(filename)

[z, R] = geotiffread(filename);



if isprop(R,'LatitudeLimits');
x = ((R.LongitudeLimits(1)+R.CellExtentInLongitude/2):R.CellExtentInLongitude:(R.LongitudeLimits(2)-R.CellExtentInLongitude/2));
y = fliplr((R.LatitudeLimits(1)+R.CellExtentInLatitude/2):R.CellExtentInLatitude:(R.LatitudeLimits(2)-R.CellExtentInLatitude/2))';
end

if isprop(R,'XWorldLimits')
x = ((R.XWorldLimits(1)+R.CellExtentInWorldX/2):R.CellExtentInWorldX:(R.XWorldLimits(2)-R.CellExtentInWorldX/2));
y = fliplr((R.YWorldLimits(1)+R.CellExtentInWorldY/2):R.CellExtentInWorldY:(R.YWorldLimits(2)-R.CellExtentInWorldY/2))';
end












