function grow_axis(gfac,axis_handle)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
%  Max an axis take up proportionally more space on the figure, keeping the
%  same center point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% gfac - The scale factor to stretch the axis
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('axis_handle') == 1
    gs = get(axis_handle,'Position');
else
    gs = get(gca,'Position');
end

dx = gs(3)*gfac;
dy = gs(4)*gfac;

sx = gs(1)+gs(3)/2-dx/2;
sy = gs(2)+gs(4)/2-dy/2;

if exist('axis_handle') == 1
    set(axis_handle,'Position',[sx sy dx dy]);
else
    set(gca,'Position',[sx sy dx dy]);
end

