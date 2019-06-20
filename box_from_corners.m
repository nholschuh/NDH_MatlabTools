function box_out = box_from_corners(x1,x2,y1,y2)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Generate a closed box given the min and max corners
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x1 - Either supply the minimum x value, or both min and max x values here
% x2 - Either supply the maximum x value, or both min and max y values here
% y1 - (if x1 and x2 are both x values) supply the minimum y value here
% y2 - (if x1 and x2 are both x values) supply the minimum y value here
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% box_out - 5x2 vector with columns as x and y values of a closed box
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('y1') == 0
    xs = x1;
    ys = x2;
    x1 = xs(1);
    x2 = xs(2);
    y1 = ys(1);
    y2 = ys(2);
else
    xs = [x1 x2];
    ys = [y1 y2];
end

box_out = [x1 y1; ...
    x2 y1; ...
    x2 y2; ...
    x1 y2; ...
    x1 y1];

end
