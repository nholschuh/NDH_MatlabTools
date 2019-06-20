function plot_box(corners,line_color,line_width);
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% corners - 2x2 vector, each row being a corner coordinate
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

corners = combvec(corners(:,1)',corners(:,2)')';
corners([3 4],:) = corners([4 3],:);
corners(end+1,:) = corners(1,:);

plot(corners(:,1),corners(:,2),'Color',line_color,'LineWidth',line_width)
end

