function [y1,y2,y3,vel_im] = A_Velocity(data_set,xys,x1,x2,y1,y2,plotter,m0_km1_flag,transparency_value)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% Generates an ice velocity map with size specifications set 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data_set - Number corresponding to the data_set of interest
%               1 - Measures data (1996 - 2011 aggregate, 450m, Rignot)
%               2 - Ian SipleCoast data (2001 - Joughin)
%               3 - Rignot 450m composite (2017)
%               4 - Mouginot Phase Velocity (2019)
%               5 - 
%               6 - 
%               7 - 
%               8 - 
% xys - This specifies whether you want ice speeds, x velocities, or y vel.
%       options: 'x','y','s'
% logs - Plots the logarithmic data or the linear data (0 or 1)
% x1 - This input can take on two types of values:
%         1) A number (either m or km, depending on a later flag) that
%            defines the left boundary of the domain of interest.
%         2) A single character string, that is used as shorthand to
%            define the domain of interest from the following:
%                 'w' - this is the western hemisphere
%                 'e' - this is the eastern hemisphere
%                 'a' - this is the whole continent (default)
%                 '1' - quadrant NE
%                 '2' - quadrant NW
%                 '3' - quadrant SW
%                 '4' - quadrant SE
% x2 - The right boundary of the domain (ignored if string for x1)
% y1 - The bottom boundary of the domain (ignored if string for x1)
% y2 - The top boundary of the domain (ignored if string for x1)
% plotter - flag that chooses whether or not to plot the image, or just
%           output the values to variable z
% m0_km1_glag - This sets whether your inputs (and outputs for gx/gy) are
%               in meters (0) or kilometers (1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y1 - the x coordinate axis
% y2 - the y coordinate axis
% y3 - the data grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('data_set') == 0
     data_set = listdlg('ListString',{'1 - Measures data (1996 - 2011 aggregate, 450m, Rignot)' ,...
        'Ian SipleCoast data (2001 - Joughin)',...
        'Rignot 450m (2017)'},'PromptString',sprintf(['Dataset Options:\n-----------------------------']))
end
if exist('xys') == 0
    xys = 's';
end

if exist('x1') == 0
    x1 = 'a';
end
if exist('plotter') == 0
    plotter = 1;
end
if exist('m0_km1_flag') == 0
    m0_km1_flag = 0;
end
if exist('transparency_value') == 0
    transparency_value = 0;
end


if data_set == 1
    if xys == 's'
        [x y z] = grdread('Antarctic_speed_1996.nc');
    elseif xys == 'x'
        [x y z] = grdread('Antarctic_vx_1996.nc');
    elseif xys == 'y';
        [x y z] = grdread('Antarctic_vy_1996.nc');
    end
elseif data_set == 2
    if xys == 's'
        [x y z] = grdread('Antarctic_2001_Ian_speed.nc');
    elseif xys == 'x'
        [x y z] = grdread('Antarctic_2001_Ian_vx.nc');
    elseif xys == 'y';
        [x y z] = grdread('Antarctic_2001_Ian_vy.nc');
    end
elseif data_set == 3
    if xys == 's'
        [x y z] = grdread('Antarctic_speed_2017.nc');
    elseif xys == 'x'
        [x y z] = grdread('Antarctic_vx_2017.nc');
    elseif xys == 'y';
        [x y z] = grdread('Antarctic_vy_2017.nc');
    end
elseif data_set == 4
     if xys == 's'
        [x y u] = grdread('antarctic_ice_vel_phase_map_v01.nc','VX',1,'x','y');
        [x y v] = grdread('antarctic_ice_vel_phase_map_v01.nc','VY',1,'x','y');
        z = sqrt(u.^2+v.^2);
        clearvars u v
    elseif xys == 'x'
        [x y z] = grdread('antarctic_ice_vel_phase_map_v01.nc','VX',1,'x','y');
    elseif xys == 'y';
        [x y z] = grdread('antarctic_ice_vel_phase_map_v01.nc','VY',1,'x','y');
     end
end
    


x = double(x);
y = double(y);

if data_set == 1 | data_set == 2 | data_set == 3
z = flipud(z);
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


if exist('x1','var') == 1
    if  x1 == 'w'
        x1 = lxvalue;
        x2 = 0;
        y1 = lyvalue;
        y2 = hyvalue;
    elseif x1 == 'e'
        x1 = 0;
        x2 = hxvalue;
        y1 = lyvalue;
        y2 = hyvalue;
    elseif x1 == 'a'
        x1 = lxvalue;
        x2 = hxvalue;
        y1 = lyvalue;
        y2 = hyvalue;
    elseif x1 == '1'
        x1 = 0;
        x2 = hxvalue;
        y1 = 0;
        y2 = hyvalue;
        source_data = 1;
    elseif x1 == '2'
        x1 = lxvalue;
        x2 = 0;
        y1 = 0;
        y2 = hyvalue;
        source_data = 1;
    elseif x1 == '3'
        x1 = lxvalue;
        x2 = 0;
        y1 = lyvalue;
        y2 = 0;
        source_data = 1;
    elseif x1 == '4'
        x1 = 0;
        x2 = hxvalue;
        y1 = lyvalue;
        y2 = 0;
        source_data = 1;
    else
        

             x1 = x1 ;


        if exist('x2','var') == 0
             x2 = hxvalue;
        else
                x2 = x2 ;
        end

        if exist('y1','var') == 0
            y1 = lyvalue;
        else
            y1 = y1 ;
        end

        if exist('y2','var') == 0
            y2 = hyvalue;
        else
            y2 = y2 ;
        end
    end
else
    
    x1 = lxvalue;

if exist('x2','var') == 0
    x2 = hxvalue;
else
    x2 = x2 ;
end

if exist('y1','var') == 0
    y1 = lyvalue;
else
    y1 = y1 ;
end

if exist('y2','var') == 0
    y2 = hyvalue;
else
    y2 = y2 ;
end
end

x1index = round((x1-lxvalue)/celldim)+1;
x2index = round((x2-lxvalue)/celldim);
y1index = round((y1-lyvalue)/celldim)+1;
y2index = round((y2-lyvalue)/celldim);

x1index = max([round((x1-min(x))/celldim)+1 1]);
x2index = min([round((x2-min(x))/celldim) length(z(1,:))]);
y1index = max([round((y1-min(y))/celldim)+1 1]);
y2index = min([round((y2-min(y))/celldim) length(z(:,1))]);

lowx = x1index*celldim+lxvalue;
lowy = y1index*celldim+lyvalue;
highx = x2index*celldim+lxvalue;
highy = y2index*celldim+lyvalue;

xscale = lowx:celldim:highx;
yscale = lowy:celldim:highy;

%% Corrects for the fact that the y data is backward
temp = length(y) - y1index + 1;
y1index = length(y) - y2index + 1;
y2index = temp;

%%



plotdata = z(y1index:y2index,x1index:x2index);

plotdata = flipud(plotdata);



if plotter == 1
    vel_im = imagesc(xscale,yscale,plotdata);
    set(gca,'YDir','Normal')
    groundingline(1);
    colormap(gmt_to_matlab_colormap(2))
    caxis([0 150])
    if transparency_value > 0
        set(vel_im,'AlphaData',transparency_value);
    end
end


    if plotter == 1
        if xys == 's'
            caxis([0 150])
        else
            caxis([-150 150])
        end
    end


y1 = xscale;
y2 = yscale;
y3 = plotdata;

end