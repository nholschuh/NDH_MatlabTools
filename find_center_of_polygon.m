function [centers] = find_center_of_polygon(polygon_mat,xs,ys)
% This doesn't find the center, but it finds the meaty part of a polygon
% best for plotting in.
    
method = 2;
if method == 1
    xsums = sum(polygon_mat,2);
    ysums = sum(polygon_mat,1);
    value_mat = xsums*ysums;
elseif method == 2
    value_mat = conv2(polygon_mat,ones(50),'same');
end

    [yinds xinds] = find(value_mat == max(max(value_mat)));
    centers(1) = double(xs(max(xinds)) + xs(min(xinds)) )/ 2;
    centers(2) = double(ys(max(yinds)) + ys(min(yinds)) )/ 2;
end
    