function grdplot(grid,var,time,xvar,yvar,plottype,colormap_chosen)
% This function reads in a NetCDF Grid and plots it with a given colormap.
% Types available are 1 = img, 2 = mesh, and 3 = surf.

if exist('colormap_chosen') == 0
    colormap_chosen = 'jet';
end

if exist('plottype') == 0
    plottype = 1;
end

if exist('var') == 1
    [x y z] = grdread(grid,var,time,xvar,yvar);
else
    [x y z] = grdread(grid);
end

if plottype == 1
    set(gca, 'YDir', 'normal');
    
    colormap(colormap_chosen);
    imagesc(x,y,z)
    set(gca, 'YDir', 'normal');
    colorbar
end

if plottype == 2
    mesh(x,y,z)
end

if plottype == 3
    surf(x,y,z,'LineStyle','none')
end

end
