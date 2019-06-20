function grdmerge(grid1,grid2,name)
% This function takes the input of two NetCDF Grid files and fills in the
% blanks of a finer grid using the known values of a coarse grid. The final
% grid resolution will be the same as for the finer original grid.

[gridx1 gridy1 gridz1] = grdread(grid1);
[gridx2 gridy2 gridz2] = grdread(grid2);

xspacing1 = abs(gridx1(2)-gridx1(1));
yspacing1 = abs(gridy1(2)-gridy1(1));

xspacing2 = abs(gridx2(2)-gridx2(1));
yspacing2 = abs(gridy2(2)-gridy2(1));

counter=1;
fillvec = [];

if xspacing1 < xspacing2
    for i = 1:length(gridx1)
        for j = 1:length(gridy1)
            if isnan(gridz1(j,i)) == 1
                fillvec(counter,:) = [gridx1(i) gridy1(j) i j gridz1(j,i)];
                counter = counter+1;
            end
        end
    end
    outergrid = grid2;
    gridx = gridx1;
    gridy = gridy1;
    Inner_gridz = gridz1;
else
    for i = 1:length(gridx2)
        for j = 1:length(gridy2)
            if isnan(gridz2(j,i)) == 1
                fillvec(counter,:) = [gridx2(i) gridy2(j) i j gridz2(j,i)];
                counter = counter+1;
            end
        end
    end
    outergrid = grid1;
    gridy = gridy2;
    gridx = gridx2;
    Inner_gridz = gridz2;
end

counter = counter-1;

zfill = grdsearch(fillvec,outergrid);

for i = 1:counter
    Inner_gridz(fillvec(i,4),fillvec(i,3)) = zfill(i);
end

gridz = Inner_gridz;

grdwrite(gridx,gridy,gridz,name);

end