function grdregrid(grid1,spacing_or_grid,filename)
%Function to regrid a coarse grid with finer spacing

[gridx gridy gridz] = grdread(grid1);

if length(spacing_or_grid > 0) > 1
    [gridxfinal gridyfinal gridz2] = grdread(spacing_or_grid);

        min_xsearch = abs(gridxfinal - min(gridx));
        max_xsearch = abs(gridxfinal - max(gridx));
        min_ysearch = abs(gridyfinal - min(gridy));
        max_ysearch = abs(gridyfinal - max(gridy));
        
        xstart = find(min_xsearch == min(min_xsearch));
        xend = find(max_xsearch == min(max_xsearch));
        ystart = find(min_ysearch == min(min_ysearch));
        yend = find(max_ysearch == min(max_ysearch));
        if yend < ystart
            gridyfinal = gridyfinal(yend:ystart);
            gridyfinal = fliplr(gridyfinal);
        else
            gridyfinal = gridyfinal(ystart:yend);
        end
        
         if xend < xstart
            gridxfinal = gridxfinal(xend:xstart);
            gridxfinal = fliplr(gridxfinal);
        else
            gridxfinal = gridxfinal(xstart:xend);
        end       
   
    
else
    spacing = spacing_or_grid;
    gridxfinal = [];
    gridyfinal = [];
    x1 = gridx(1);
    y1 = gridy(1);
    counter = 1;
    
    gridxfinal(counter) = x1;
    counter = counter+1;
    while gridxfinal(counter-1) <= gridx(length(gridx))
        gridxfinal(counter) = gridxfinal(counter-1)+spacing;
        counter = counter+1;
    end
    counter = 1;
    gridyfinal(counter) = y1;
    counter = counter+1;
    while gridyfinal(counter-1) <= gridy(length(gridy))
        gridyfinal(counter) = gridyfinal(counter-1)+spacing;
        counter = counter+1;
    end
end


vq = griddata(gridx,gridy,gridz,gridxfinal,gridyfinal');

grdwrite(gridxfinal,gridyfinal,vq,filename);
end