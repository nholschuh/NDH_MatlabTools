function outcircle = circle_ndh(x_center,y_center,radius);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% This function generates a circle for plotting with a given center
% coordinate and radius
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x_center - 
% y_center - 
% radius - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% outcircle - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if length(radius) == 1
    radius = ones(size(x_center))*radius;
end

for i = 1:length(x_center);
    th = 0:pi/50:2*pi;
    xunit = radius(i) * cos(th) + x_center(i);
    yunit = radius(i) * sin(th) + y_center(i);
    
    outcircle(i).xy = [xunit' yunit'];
end

end