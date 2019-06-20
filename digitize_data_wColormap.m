function [outmat xaxis yaxis d_colormap caxis_vals] = digitize_data_wColormap(image_file);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% image_file - The name of the image file to read in and digitize from  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% outmat - The matrix of values from the digitized image
% xaxis - The xaxis corresponding to the matrix of values
% yaxis - The yaxis corresponding to the matrix of values
% d_colormap - the colormap for the plotted data
% caxis_vals - the caxis for the colormap of the plotted data;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


data = imread(image_file);
imagesc(data)
maximize
axis equal
title('Calibration Points')

[calibration_points trash calibration_vals] = graphical_selection(2,0,1);

%%%%%%%%%%% Find the minimum difference in the x position of selected
%%%%%%%%%%% points
diffmat = abs([calibration_points(:,2)-calibration_points(:,2)']);
for i = 1:length(diffmat(:,1))
    diffmat(i,i) = Inf;
end
minval = min(min(diffmat));

if minval < 10
    %%%%%%%%%%%%% assume selections on axes
    axis1 = [1 find(min(diffmat(:,1)) == diffmat(:,1))];
    axis2 = find([1:4] ~= 1 & [1:4] ~= axis1(2));
    
    [cvx] = polyfit(calibration_points(axis1,1),calibration_vals(axis1,1),1);
    [cvy] = polyfit(calibration_points(axis2,2),calibration_vals(axis2,2),1);    
else
    %%%%%%%%%%%%% assume selections are distributed across the image,
    %%%%%%%%%%%%% develop conversion functions for the x/y coordinates
    
    [cvx] = polyfit(calibration_points(:,1),calibration_vals(:,1),1);
    [cvy] = polyfit(calibration_points(:,2),calibration_vals(:,2),1);
end

title('Define X Axis');
xaxis_inds = graphical_selection(1);
title('Define Y Axis');
yaxis_inds = graphical_selection(1);


xaxis = polyval(cvx,round(min(xaxis_inds(:,1))):round(max(xaxis_inds(:,1))));
yaxis = polyval(cvy,round(min(yaxis_inds(:,2))):round(max(yaxis_inds(:,2))));


%%%%%%%%%%%%%%%%%%%%%%% This section has you calibrate the colormap, and
%%%%%%%%%%%%%%%%%%%%%%% the values are extracted.
title('Define Colormap');
[calibration_points_cmap trash calibration_vals_cmap] = graphical_selection(2,0,1);

xdiff_cmap = max(calibration_points_cmap(:,1))-min(calibration_points_cmap(:,1));
ydiff_cmap = max(calibration_points_cmap(:,2))-min(calibration_points_cmap(:,2));

if xdiff_cmap > ydiff_cmap
    caxis_fit = polyfit(calibration_points_cmap(:,1),calibration_vals_cmap(:,1),1);
    caxis_x = round(min(calibration_points_cmap(:,1)):max(calibration_points_cmap(:,1)));
    caxis_y = round(ones(size(caxis_x))*mean(calibration_points_cmap(:,2)));
    caxis_vals = polyval(caxis_fit,caxis_x);
else
    caxis_fit = polyfit(calibration_points_cmap(:,2),calibration_vals_cmap(:,2),1);
    caxis_y = round(min(calibration_points_cmap(:,2)):max(calibration_points_cmap(:,2)));
    caxis_x = round(ones(size(caxis_y))*mean(calibration_points_cmap(:,1)));
    caxis_vals = polyval(caxis_fit,caxis_y);
end

c1 = squeeze(data(:,:,1));
c2 = squeeze(data(:,:,2));
c3 = squeeze(data(:,:,3));

c1s = matsearch([caxis_x' caxis_y'],1:length(c1(1,:)),1:length(c1(:,1)),double(c1));
c2s = matsearch([caxis_x' caxis_y'],1:length(c1(1,:)),1:length(c1(:,1)),double(c2));
c3s = matsearch([caxis_x' caxis_y'],1:length(c1(1,:)),1:length(c1(:,1)),double(c3));

d_colormap = [c1s c2s c3s]/255;

if max(caxis_vals) == caxis_vals(1)
    caxis_vals = fliplr(caxis_vals);
    d_colormap = flipud(d_colormap);
end

%%%%%%%%%%%%%%%%%% Find whether R, G, or B has the greatest variance:
cvar(1) = max(d_colormap(:,1))-min(d_colormap(:,1));
cvar(2) = max(d_colormap(:,2))-min(d_colormap(:,2));
cvar(3) = max(d_colormap(:,3))-min(d_colormap(:,3));

cind = find(max(cvar) == cvar);
cind = cind(1);
if cind == 1
    matcolor_search = c1;
    ccomp = d_colormap(:,1);
elseif cind == 2
    matcolor_search = c2;
    ccomp = d_colormap(:,2);    
elseif cind == 3
    matcolor_search = c3;
    ccomp = d_colormap(:,3);    
end

%%%%%%%%%%%% Compare the matrix colors to the most variant color of the
%%%%%%%%%%%% primaries, and extract the values
im_c_data = double(matcolor_search(round(min(yaxis_inds(:,2))):round(max(yaxis_inds(:,2))),...
    round(min(xaxis_inds(:,1))):round(max(xaxis_inds(:,1)))))/255;
im_c_vec = matrix_to_vector(im_c_data);
val_inds = find_nearest(ccomp,im_c_vec);
vals = caxis_vals(val_inds);

outmat = vector_to_matrix(vals,size(im_c_data));


end








