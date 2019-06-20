function    grdpaint2(grid1,outputname,overlay)
% Allows you to manipulate elevation values on a grid


if exist('overlay') == 0
    overlay = [NaN NaN NaN];
end

reduction_scalar = 50;

plotnum = 1;
grdplot(grid1,1)
hold all
scatter(overlay(:,1),overlay(:,2),3,overlay(:,3));


[gridx gridy gridz] = grdread(grid1);


gridvec = zeros(length(gridx)*length(gridy),3);
for i = 1:length(gridx)
    for j = 1:length(gridy)
        gridvec((i-1)*length(gridy)+j,1) = gridx(i);
        gridvec((i-1)*length(gridy)+j,2) = gridy(j);
        gridvec((i-1)*length(gridy)+j,3) = gridz(j,i);
        gridvec((i-1)*length(gridy)+j,4) = i;
        gridvec((i-1)*length(gridy)+j,5) = j;
    end
end



 
   xmin = min(gridx);
   xmax = max(gridx);
   ymin = min(gridy);
   ymax = max(gridy);

   xrange = xmax-xmin;
   yrange = ymax-ymin;
   
   zoominfactor =  .4;                   %Value between 0-1
   zoomoutfactor = 1/zoominfactor;

contour_storage = [];

i = 1;
start = 1;
temp = zeros(1,3);




while i == 1
    temp = zeros(1,3);
    [temp(1),temp(2),temp(3)] = ginput(1);
    contour_storage(i,:) = temp;
    ContourPicker_KeyFunctions2      %Tool set for zooming, next line
    
    if contour_storage(i,3) == 3
        ud = -1;
    end
    
    if contour_storage(i,3) == 1
        ud = 1;
    end
        
    if contour_storage(i,3) < 4
        tempresult = matrixsearch(contour_storage(i,1:2),gridx,gridy,gridz);
        xi = tempresult(1);
        yi = tempresult(2);
         gridz(yi,xi) = gridz(yi,xi) - 1.00*reduction_scalar*ud;
       
             
        set(gca, 'YDir', 'normal');
    
        colormap(jet);
        imagesc(gridx,gridy,gridz)
        set(gca, 'YDir', 'normal');
        colorbar
    end
    i = i+1;
end
if i > 1
    while contour_storage(i-1,3) ~= 113
        if contour_storage(i-1,3) == 110
            contour_storage(i-1,:) = [0 0 10];
            start = i;
            close all
            colormap(jet);
            imagesc(gridx,gridy,gridz)
            hold all
            set(gca, 'YDir', 'normal');
            colorbar
            grdwrite(gridx,gridy,gridz,'grdpaint_temp');
        end
       
        temp = zeros(1,3);
        [temp(1),temp(2),temp(3)] = ginput(1);
        contour_storage(i,:) = temp;

        ContourPicker_KeyFunctions2;
        
        if contour_storage(i,3) == 3
            ud = -1;
        end
        
        if contour_storage(i,3) == 1
            ud = 1;
        end
        
        if contour_storage(i,3) < 4 & contour_storage(i,3) > 0
            tempresult = matrixsearch(contour_storage(i,1:2),gridx,gridy,gridz);
            xi = tempresult(1);
            yi = tempresult(2);
         gridz(yi,xi) = gridz(yi,xi) - 1.00*reduction_scalar*ud;
        
                 set(gca, 'YDir', 'normal');
            
            colormap(jet);
            imagesc(gridx,gridy,gridz)
            set(gca, 'YDir', 'normal');
            colorbar
        end
        i = i+1;
    end
end

delete grdpaint_temp
grdwrite(gridx,gridy,gridz,outputname);

end
