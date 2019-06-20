function zfinal = grdsearch(inputvec,grid,grid_params,four_point)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This searches a given grid and extracts the values at provided points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputvec - stereographic coordinates for the points of interest
% grid - name / path to a NetCDF Grid of interest
% [grid_params] - If using a multivariate or multi-time-slice NetCDF, you
%        have the option to enter the variable names or timeslices here
%        {zvar_name}
%        {xvar_name yvar_name zvar_name}
%        {xvar_name yvar_name zvar_name timeslice}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% z - The extracted value at points defined by inputvec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes all points provided in the first two columns of the inputvec and returns the value at that location in the grid. grid provided as a string containing the address of the grid file relative to the pwd.

x=inputvec(:,1);
y=inputvec(:,2);
z = zeros(length(x),1);

if exist('four_point') == 0
    four_point = 0;
end

if exist('grid_params') == 0
    [gridx gridy gridz] = grdread(grid);
elseif length(grid_params) == 1
    [gridx gridy gridz] = grdread(grid,grid_params{1});
elseif length(grid_params) == 3
    [gridx gridy gridz] = grdread(grid,grid_params{3},0,grid_params{1},grid_params{2});
elseif length(grid_params) == 4
    [gridx gridy gridz] = grdread(grid,grid_params{1},grid_params{2},grid_params{3},grid_params{4});
end

if isa(gridx,'double') == 0
    gridx = double(gridx);
end
if isa(gridy,'double') == 0
    gridy = double(gridy);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This accounts for grid searching for
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% irregular grids, starting with the
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% regular grid case.

if min(size(gridx)) == 1
    xmin = gridx(1);
    
    if gridy(1) < gridy(length(gridy))
        ymin = gridy(length(1));
    else
        ymin = gridy(length(gridy));
    end
    
    xspacing = abs(gridx(2)-gridx(1));
    yspacing = abs(gridy(2)-gridy(1));
    
    xsearch = x-xmin-.5*xspacing;
    ysearch = y-ymin-.5*yspacing;
    
    xsearch = floor(xsearch/xspacing)+1;
    
    %%%%%%%%%%%%%%% This deals with a flipped y axis
    if gridy(1) < gridy(length(gridy))
        ysearch = floor(ysearch/yspacing)+1;
    else
        ysearch = length(gridy) - floor(ysearch/yspacing)+1;
    end
    

    %%%%%%%%%%%%%%%% New (09/05/18) taken from matsearch. If doesn't work,
    %%%%%%%%%%%%%%%% use below.
    %%%%% Find the indecies out of the grid
    nan_inds = find(xsearch > length(gridx) | xsearch < 1 | ysearch > length(gridy) | ysearch < 1);
    
    xsearch(nan_inds) = 1;
    ysearch(nan_inds) = 1;
    

    matinds = sub2ind(size(gridz),ysearch,xsearch);
    
    if four_point == 0
        
        zfinal = gridz(matinds);


        xsearch(nan_inds) = NaN;
        ysearch(nan_inds) = NaN;
        xfinal(nan_inds) = NaN;
        
        gridinds = [ysearch xsearch];
        
    elseif four_point > 0
        zfinal = interp2(gridx,gridy,gridz,inputvec(:,1),inputvec(:,2));
    end       
    
        
    %%%%%% This reshapes the final matrix to its original configuration, if the
    %%%%%% input was an x matrix and y matrix
    if iscell(inputvec)
        zfinal = vector_to_matrix(zfinal,vs);
    end
    
%%%%%%%%%%%%%%%%%% Old (as of 09/05/2018) - delete if new works
%     for i = 1:length(z)
%         if xsearch(i) > length(gridx) | xsearch(i) < 1 | ysearch(i) > length(gridy) | ysearch(i) < 1
%             z(i) = NaN;
%         else
%             z(i) = gridz(ysearch(i),xsearch(i));
%         end
%     end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The irregular grid case
else
    
    if size(gridx) == size(gridz')
        gx = gridx';
        gy = gridy';
    else
        gx = gridx;
        gy = gridy;
    end
    gx_vec = matrix_to_vector(gx,1);
    gy_vec = matrix_to_vector(gy,1);
    gz_vec = matrix_to_vector(gridz,1);
    
    z_inds = find_nearest_xy([gx_vec gy_vec],inputvec);
    z = gz_vec(z_inds);
    zfinal = z;
end



