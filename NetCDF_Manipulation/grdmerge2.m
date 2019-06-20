function grdmerge2(grid1,grid2,name)
% This function takes the input of two NetCDF Grid files and fills in the
% blanks of a finer grid using the known values of a coarse grid. The final
% grid resolution will be the same as for the finer original grid.


grdregrid(grid2,grid1,'temp.grid');

[gridx gridy gridz] = grdread(grid1);
[gridx2 gridy2 gridz2] = grdread('temp.grid');

for i = 1:length(gridx)
    for j = 1:length(gridy)
        if isnan(gridz(j,i)) == 1
            gridz(j,i) = gridz2(j,i);
        end
    end
end

delete temp.grid

grdwrite(gridx,gridy,gridz,name);
