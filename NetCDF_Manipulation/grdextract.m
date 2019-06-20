function grdextract(grid1,grid2,name,scalefactor)
% Extracts a grid covering the region in grid 2, from the larger grid 1,
% and ouptuts this with the name specified.

if exist('scalefactor') == 0
    scalefactor = 1;
end

[gridx1 gridy1 gridz1] = grdread(grid1);
[gridx2 gridy2 gridz2] = grdread(grid2);

minx = min(gridx2);
maxx = max(gridx2);

miny = min(gridy2);
maxy = max(gridy2);


tempxmin = abs(gridx1 - minx);
tempxmax = abs(gridx1 - maxx);

tempymin = abs(gridy1 - miny);
tempymax = abs(gridy1 - maxy);

xind_min = find(tempxmin == min(tempxmin));
xind_max = find(tempxmax == min(tempxmax));

yind_min = find(tempymin == min(tempymin));
yind_max = find(tempymax == min(tempymax));

if yind_min > yind_max
    temp = yind_min;
    yind_min = yind_max;
    yind_max = temp;
    flipy = 1;
end

if xind_min > xind_max
    temp = xind_min;
    xind_min = xind_max;
    xind_max = temp;
    flipx = 1;
end


scaler = xind_min - round(xind_min*scalefactor);
xind_min = xind_min-scaler;
xind_max = xind_max+scaler;
yind_min = yind_min-scaler;
yind_max = yind_max+scaler;

newgridx = gridx1(xind_min:xind_max);

newgridy = gridy1(yind_min:yind_max);



newgridz = gridz1(yind_min:yind_max,xind_min:xind_max);

if exist('flipy') == 1
    newgridy = fliplr(newgridy);
    newgridz = flipud(newgridz);
end
if exist('flipx') == 1
    newgridx = fliplr(newgridx);
    newgridz = fliplr(newgridz);
end


grdwrite(newgridx,newgridy,newgridz,name);

end