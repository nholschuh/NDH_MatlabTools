function grdplot_animate(grid,plottype,colormap_chosen)
% This function reads in a NetCDF Grid and plots it with a given colormap.
% Types available are 1 = img, 2 = mesh, and 3 = surf.

if exist('colormap_chosen') == 0
    colormap_chosen = 'jet';
end

if exist('plottype') == 0
    plottype = 1;
end



[x y z] = grdread_animate(grid);
cmin = min(min(min(z)));
cmax = max(max(max(z)));

for i = 1:length(z(1,1,:))
    if plottype == 1
        if i == 1
            y = fliplr(y);
        end
        x = x;
        ztemp = flipud(z(:,:,i));
        set(gca, 'YDir', 'normal');
    
        colormap(colormap_chosen);
        imagesc(x,y,ztemp)
        set(gca, 'YDir', 'normal');
        colorbar
        set(gca,'CLim',[cmin cmax])
    end
    
    if plottype == 2
        ztemp = z(:,:,i);
        mesh(x,y,ztemp)
    end
    
    if plottype == 3
        ztemp = z(:,:,i);
        surf(x,y,ztemp,'LineStyle','none')
    end
    pause(1)
end

end