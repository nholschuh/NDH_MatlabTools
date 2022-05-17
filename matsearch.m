function [zfinal matinds gridinds dist_final]= matsearch(inputvec,gridx,gridy,gridz,four_point)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This searches a given matrix and extracts the values at provided points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputvec - stereographic coordinates for the points of interest this can
%           take the form of either an Nx2 matrix, or cell array with two
%           NxM arrays for the x and y coordinates
% gridx /gridy /gridz - the axes and data matrix to be searched
% four_point - this is a flag that indicates whether you want just the nearest
%           value [0] , or all for of the adjacent values [1] , or the weighted
%           average of them [2]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zfinal - The extracted value at points defined by inputvec
% matinds - the index in the grid associated with the data
% gridinds - the row and column in the grid associated with the data
% dist_final - the distance between the input point and the grid index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes all points provided in the first two columns of the inputvec and returns the value at that location in the grid. grid provided as a string containing the address of the grid file relative to the pwd.


%%
%%%%%%%%%%%%%%%%%%%%%% Testing
% testflag = 1;
% inputvec = [2.5,3];
% gridz = [1:5; 2:6; 3:7; 4:8];
% gridx = 1:5;
% gridy = 1:4;
% four_point = 2;

testflag = 0;

if iscell(inputvec) == 1
    [x vs] = matrix_to_vector(inputvec{1});
    y = matrix_to_vector(inputvec{2});
    z = zeros(size(x));
else
    x=inputvec(:,1);
    y=inputvec(:,2);
    z = zeros(length(x),1);
end

if exist('four_point') == 0
    four_point = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The first solution works for a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% square grid with orthogonal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% axes - in the event that you
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% are searching a meshgrid, a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% different solution is required.

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
    nan_inds = find(xsearch > length(gridx) | xsearch < 1 | ysearch > length(gridy) | ysearch < 1 | isnan(xsearch) == 1);
    
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
        gridinds(:,1) = find_nearest(gridy,y);
        gridinds(:,2) = find_nearest(gridx,x);
        zfinal = interp2(gridx,gridy,gridz,x,y);
    end
    
    
    %%%%%% This reshapes the final matrix to its original configuration, if the
    %%%%%% input was an x matrix and y matrix
    if iscell(inputvec)
        zfinal = vector_to_matrix(zfinal,vs);
    end
    
    
    
else
    %%%%%%%%%%%%%%%%%%%%%%%% Here is the solution for the meshgrid search.
    zfinal = ones(length(inputvec(:,1)),1)*NaN;
    gridinds = ones(length(inputvec(:,1)),2)*NaN;
    
    slant_down_or_up = sign(gridy(1,1) - gridy(1,2))*-1;
    
    for i = 1:length(gridx(:,1))
        for j = 1:length(gridx(1,:))
            
            %%%%%%%%%%%%%%%%% Establish the polygon centered on the grid
            %%%%%%%%%%%%%%%%% vertex
            if i ~= 1
                dy2 = abs(gridy(i,j) - gridy(i-1,j))/2;
                dx2 = abs(gridx(i,j) - gridx(i-1,j))/2;
            else
                dy2 = abs(gridy(i+1,j) - gridy(i,j))/2;
                dx2 = abs(gridx(i+1,j) - gridx(i,j))/2;
            end
            if j ~= 1
                dx1 = abs(gridx(i,j) - gridx(i,j-1))/2;
                dy1 = abs(gridy(i,j) - gridy(i,j-1))/2;
            else
                dx1 = abs(gridx(i,j+1) - gridx(i,j))/2;
                dy1 = abs(gridy(i,j+1) - gridy(i,j))/2;
            end
            
            if slant_down_or_up > 0
                polysearch = [gridx(i,j)+dx1+dx2 gridy(i,j)+dy1-dy2; ...
                    gridx(i,j)-dx1+dx2 gridy(i,j)-dy1-dy2; ...
                    gridx(i,j)-dx1-dx2 gridy(i,j)-dy1+dy2; ...
                    gridx(i,j)+dx1-dx2 gridy(i,j)+dy1+dy2; ...
                    gridx(i,j)+dx1+dx2 gridy(i,j)+dy1-dy2];
            else
                polysearch = [gridx(i,j)-dx1+dx2 gridy(i,j)+dy1+dy2; ...
                    gridx(i,j)+dx1+dx2 gridy(i,j)-dy1+dy2; ...
                    gridx(i,j)+dx1-dx2 gridy(i,j)-dy1-dy2; ...
                    gridx(i,j)-dx1-dx2 gridy(i,j)+dy1-dy2; ...
                    gridx(i,j)-dx1+dx2 gridy(i,j)+dy1+dy2];
            end
            
            
            inds = find(within(inputvec(:,1),inputvec(:,2),polysearch(:,1),polysearch(:,2)));
            if length(inds) > 0
                zfinal(inds) = gridz(i,j);
                gridinds(inds,:) = repmat([i j],length(inds),1);
            end
            
            debug_plot = 0;
            
            if debug_plot == 1
                hold off
                pcolor(gridx,gridy,gridz);
                shading interp;
                hold all
                plot(inputvec(:,1),inputvec(:,2),'.','Color','black')
                plot(gridx(i,j),gridy(i,j),'.','Color','red')
                plot(polysearch(:,1),polysearch(:,2),'Color','black')
                title(num2str(length(inds)))
                pause(0.00001)
            end
            
        end
    end
    
    
end



if testflag == 1
    hold off
    imagesc(gridx,gridy,gridz);
    hold all
    plot(inputvec(:,1),inputvec(:,2),'o','Color','black','MarkerFaceColor','black','MarkerSize',20)
    scatter(inputvec(:,1),inputvec(:,2),200,zfinal,'filled')
    title(num2str(zfinal))
end

end









