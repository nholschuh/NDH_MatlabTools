function set_axissize(xsize,ysize,in0_or_cm1)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This sets the figure to an explicit size in inches or cm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% xsize - the length of the x axis
% ysize - the length of the y axis
% in0_or_cm1 - [0] inches or 1 centimeters
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('in0_or_cm1') == 0
    in0_or_cm1 = 0;
end

in_to_cm = 2.54;

if in0_or_cm1 == 1
    xsize = xsize*in_to_cm;
    ysize = ysize*in_to_cm;
end

start = get(gcf,'Position');
xs = get(gca,'XLim');
ys = get(gca,'YLim');

set(gcf,'Position',[start(1:2) xsize*100/0.8 ysize*100/0.8]);
set(gca,'Position',[0.1 0.1 0.8 0.8]);
set(gca,'XLim',xs,'YLim',ys)

end










