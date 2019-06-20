function [y1,y2,y3] = matsubset(x1,x2,y1,y2,xaxis,yaxis,zdata,m0_km1_flag)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This subsets a gridded data set according to the bounding coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x1 - This input can take on two types of values:
%         1) A number (either m or km, depending on a later flag) that
%            defines the left boundary of the domain of interest.
% x2 - The right boundary of the domain (ignored if string for x1)
% y1 - The bottom boundary of the domain (ignored if string for x1)
% y2 - The top boundary of the domain (ignored if string for x1)
% gridx /gridy /gridz - the axes and data matrix to be searched
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% z - The extracted value at points defined by inputvec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes all points provided in the first two columns of the inputvec and returns the value at that location in the grid. grid provided as a string containing the address of the grid file relative to the pwd.



x = double(xaxis);
y = double(yaxis);


if exist('m0_km1_flag') == 0
    m0_km1_flag = 0;
end
    
if m0_km1_flag == 1
    x = x/1000;
    y = y/1000;
end

xsteps = length(x);
ysteps = length(y);
celldim = abs(x(2)-x(1));

lxvalue = min(x);
lyvalue = min(y);
hxvalue = max(x);
hyvalue = max(y);

x1index = round((x1-lxvalue)/celldim)+1;
x2index = round((x2-lxvalue)/celldim);
y1index = round((y1-lyvalue)/celldim)+1;
y2index = round((y2-lyvalue)/celldim);


lowx = x1index*celldim+lxvalue;
lowy = y1index*celldim+lyvalue;
highx = x2index*celldim+lxvalue;
highy = y2index*celldim+lyvalue;

xscale = lowx:celldim:highx;
yscale = lowy:celldim:highy;

plotdata = zdata(y1index:y2index,x1index:x2index);

y1 = xscale;
y2 = yscale;
y3 = plotdata;
end