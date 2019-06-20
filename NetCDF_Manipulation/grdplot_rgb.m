function grdplot_rgb(grid,var,time,xvar,yvar,plottype)
% This function reads in a NetCDF Grid and plots it with a given colormap.
% Types available are 1 = img, 2 = mesh, and 3 = surf.



if exist('plottype') == 0
    plottype = 1;
end

if exist('var') == 1
    [x y z1] = grdread([grid,'r.nc'],var,time,xvar,yvar);
    [x y z2] = grdread([grid,'g.nc'],var,time,xvar,yvar);
    [x y z3] = grdread([grid,'b.nc'],var,time,xvar,yvar);
else
    [x y z1] = grdread([grid,'r.nc']);
    [x y z2] = grdread([grid,'g.nc']);
    [x y z3] = grdread([grid,'b.nc']);
end

z(:,:,1) = z1;
z(:,:,2) = z2;
z(:,:,3) = z3;

z = z./max(max(max(z)));

if plottype == 1
    set(gca, 'YDir', 'normal');
    
    imagesc(x,y,z)
    set(gca, 'YDir', 'normal');
    colorbar
end


end
