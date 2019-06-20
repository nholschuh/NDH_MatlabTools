function line_result = find_contourline(xyzdata,contour_value)
% Takes in 2d point data and finds the contour line at a given value
xrange = min(xyzdata(:,1)) : round((max(xyzdata(:,1))-min(xyzdata(:,1)))/1000) : max(xyzdata(:,1));
yrange = min(xyzdata(:,2)) : round((max(xyzdata(:,1))-min(xyzdata(:,1)))/1000) : max(xyzdata(:,2));

vq = interp2(xyzdata(:,1),xyzdata(:,2),xyzdata(:,3),xrange,yrange);