function [x y data] = grid_subset(x1,x2,y1,y2,x_axis,y_axis,data,m0_km1_flag,y_reverse)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
% This is designed to take an input gridded data set and reduce it to just
% the region of interest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% x1 - The X coordinate for the lower left corner
% x2 - The X coordinate for the upper right corner
% y1 - The Y coordinate for the lower left corner
% y2 - The Y coordinate for the upper right corner
% x_axis - The x axis for the gridded data
% y_axis - The y axis for the gridded data
% data - The gridded data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% x_axis - The cropped x axis
% y_axis - The cropped y axis
% data - The cropped data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Dependencies are:
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('m0_km1_flag') == 0
    m0_km1_flag = 0;
end
if exist('y_reverse') == 0
    y_reverse = 0;
end

if m0_km1_flag == 1
    x_axis = x_axis/1000;
    y_axis = y_axis/1000;
end


%%%%%%%%%%%%%%%%%% debug section
if 0
    imagesc(x_axis,y_axis,data)
    hold all
    plot_box([x1 y1; x2 y2],'blue');
end

celldimx = abs(x_axis(2)-x_axis(1));
celldimy = abs(y_axis(2)-y_axis(1));

lxvalue = min(x_axis);
lyvalue = min(y_axis);
hxvalue = max(x_axis);
hyvalue = max(y_axis);

x1index = round((x1-lxvalue)/celldimx)+1;
x2index = round((x2-lxvalue)/celldimx);
y1index = round((y1-lyvalue)/celldimy)+1;
y2index = round((y2-lyvalue)/celldimy);

lowx = x1index*celldimx+lxvalue;
lowy = y1index*celldimy+lyvalue;
highx = x2index*celldimx+lxvalue;
highy = y2index*celldimy+lyvalue;

xscale = lowx:celldimx:highx;
yscale = lowy:celldimy:highy;

if y_reverse == 1
    %%% Corrects for the fact that the y data is backward
    temp = length(y) - y1index;
    y1index = length(y) - y2index;
    y2index = temp;
end

y1index = max([y1index 1]);
y2index = min([y2index length(data(:,1))]);
x1index = max([x1index 1]);
x2index = min([x2index length(data(1,:))]);


data = data(y1index:y2index,x1index:x2index);

x = xscale;
y = yscale;

end










