function plot_box(corners,line_color,line_width);
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% corners - 2x3 vector, each row being a corner coordinate
% line_color - string or 3 element array with a color value
% line_width - line width value
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% (none)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Dependencies are:
%
% (none)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('line_color') == 0
    line_color = 'black';
end
if exist('line_width') == 0
    line_width = 1;
end

corners = combvec(corners(:,1)',corners(:,2)',corners(:,3)')';
bottom = [1 2 4 3 1];
top = [5 6 8 7 5];
arm1 = [1 5];
arm2 = [2 6];
arm3 = [3 7];
arm4 = [4 8];


plot3(corners(bottom,1),corners(bottom,2),corners(bottom,3),'Color',line_color,'LineWidth',line_width)
hold all
plot3(corners(top,1),corners(top,2),corners(top,3),'Color',line_color,'LineWidth',line_width)
plot3(corners(arm1,1),corners(arm1,2),corners(arm1,3),'Color',line_color,'LineWidth',line_width)
plot3(corners(arm2,1),corners(arm2,2),corners(arm2,3),'Color',line_color,'LineWidth',line_width)
plot3(corners(arm3,1),corners(arm3,2),corners(arm3,3),'Color',line_color,'LineWidth',line_width)
plot3(corners(arm4,1),corners(arm4,2),corners(arm4,3),'Color',line_color,'LineWidth',line_width)
end

