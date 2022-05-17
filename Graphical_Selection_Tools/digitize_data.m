function [outdata xaxis yaxis] = digitize_data(image_file,datatype,lat_lon_to_stereo_flag);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% image_file - the filename for the image to digitize
% datatype - points [0] or images (1)
% lat_lon_to_stereo_flag - [0] normal stereographic data [1] latlon data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% outdata - these points that are digitzed
% axes - the x and y axes
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('datatype') == 0
    datatype = 0;
end

data = imread(image_file);
imagesc(data)
maximize
axis equal
title('Calibration Points')

[calibration_points trash calibration_vals] = graphical_selection(2,0,1);
    
if exist('lat_lon_to_stereo_flag') == 0
    lat_lon_to_stereo_flag = 0;
end

if lat_lon_to_stereo_flag == 1
    [calibration_vals(:,1) calibration_vals(:,2)] = polarstereo_fwd(calibration_vals(:,2),calibration_vals(:,1));
end

%%%%%%%%%%% Find the minimum difference in the x position of selected
%%%%%%%%%%% points
diffmat = abs([calibration_points(:,2)-calibration_points(:,2)']);
for i = 1:length(diffmat(:,1))
    diffmat(i,i) = Inf;
end
minval = min(min(diffmat));

if minval < 10 & lat_lon_to_stereo_flag == 0
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

%%%%%%%%%%%% For point data
if datatype == 0
    title('Select Points');
    outdata_inds = graphical_selection(1); 
    
    outdata(:,1) = polyval(cvx,outdata_inds(:,1));
    outdata(:,2) = polyval(cvy,outdata_inds(:,2));
elseif datatype == 1
    outdata = data(round(min(yaxis_inds(:,2))):round(max(yaxis_inds(:,2))), ...
        round(min(xaxis_inds(:,1))):round(max(xaxis_inds(:,1))),:);
end

end
















