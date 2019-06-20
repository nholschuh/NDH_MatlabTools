function [y1,y2,y3,velname] = G_Velocity(data_set,xys,x1,x2,y1,y2,plotter,m0_km1_flag,transparency)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% Generates an ice velocity map with size specifications set. The old ice
% velocity data are projected with a center longitude of -39, while the vx
% and vy of the new data are projected with -45 center longitude.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data_set - Number corresponding to the data_set of interest
%               1 - Measures 2015 mosaic
%               2 - Measures 2008-09 Data
%               3 - Measures 2000-01 Data
%               4 - Measures 2005-06 Data
%               5 - Measures 2006-07 Data
%               6 - Measures 2007-08 Data
%               7 - Measures 2009-10 Data
%               8 - Measures 2012-13 Data
%               9 - Sentinal1 2014-15 Data
%               10 - Sentinal1 2015-16 Data
%               11 - Sentinal1 2016-17 Data

% xys - This specifies whether you want ice speeds, x velocities, or y vel.
%       options: 'x','y','s'
% logs - Plots the logarithmic data or the linear data
% x1 - This input can take on two types of values:
%         1) A number (either m or km, depending on a later flag) that
%            defines the left boundary of the domain of interest.
%         2) A single character string, that is used as shorthand to
%            define the domain of interest from the following:
%                 'w' - this is the western half
%                 'e' - this is the eastern half
%                 'a' - this is the whole island (default)
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
% The outputs are:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y1 - the x coordinate axis
% y2 - the y coordinate axis
% y3 - the data grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    data_set_opts = {'1 - Measures 2015 mosaic' ,...
        '2 - Measures 2008-09 Data', ...
        '3 - Measures 2000-01 Data', ...
        '4 - Measures 2005-06 Data', ...
        '5 - Measures 2006-07 Data', ...
        '6 - Measures 2007-08 Data', ...
        '7 - Measures 2009-10 Data', ...
        '8 - Measures 2012-13 Data', ...
        '9 - Sentinal1 2014-15 Data', ...
        '10 - Sentinal1 2015-16 Data', ...
        '11 - Sentinal1 2016-17 Data'};

if exist('data_set') == 0
     data_set = listdlg('ListString',data_set_opts,'PromptString',sprintf(['Dataset Options:\n-----------------------------']))
end
if exist('xys') == 0
    xys = 's';
end

if exist('transparency') ~= 1
    transparency = 0;
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

if data_set == 1
    if xys == 's'
        [x y z] = grdread('greenland_vel_mosaic250_v1.nc');
    elseif xys == 'x'
        [x y z] = grdread('greenland_vel_mosaic250_vx_v1.nc');
    elseif xys == 'y';
        [x y z] = grdread('greenland_vel_mosaic250_vy_v1.nc');
    end
elseif data_set == 2
    if xys == 's'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2008_2009_v2.nc');
    elseif xys == 'x'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2008_2009_vx_v2.nc');
    elseif xys == 'y';
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2008_2009_vy_v2.nc');
    end
elseif data_set == 3
    if xys == 's'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2000_2001_v2.nc');
    elseif xys == 'x'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2000_2001_vx_v2.nc');
    elseif xys == 'y';
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2000_2001_vy_v2.nc');
    end
elseif data_set == 4
    if xys == 's'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2005_2006_v2.nc');
    elseif xys == 'x'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2005_2006_vx_v2.nc');
    elseif xys == 'y';
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2005_2006_vy_v2.nc');
    end
elseif data_set == 5
    if xys == 's'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2006_2007_v2.nc');
    elseif xys == 'x'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2006_2007_vx_v2.nc');
    elseif xys == 'y';
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2006_2007_vy_v2.nc');
    end
elseif data_set == 6
    if xys == 's'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2007_2008_v2.nc');
    elseif xys == 'x'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2007_2008_vx_v2.nc');
    elseif xys == 'y';
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2007_2008_vy_v2.nc');
    end    
elseif data_set == 7
    if xys == 's'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2009_2010_v2.nc');
    elseif xys == 'x'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2009_2010_vx_v2.nc');
    elseif xys == 'y';
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2009_2010_vy_v2.nc');
    end
elseif data_set == 8
    if xys == 's'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2012_2013_v2.nc');
    elseif xys == 'x'
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2012_2013_vx_v2.nc');
    elseif xys == 'y';
        [x y z] = grdread('GMT_greenland_vel_mosaic500_2012_2013_vy_v2.nc');
    end
elseif data_set == 9
    if xys == 's'
        [x y z] = grdread('greenland_iv_500m_s1_20141101_20151201_v1_0.nc','land_ice_surface_velocity_magnitude',1,'x','y');
    elseif xys == 'x'
        [x y z] = grdread('greenland_iv_500m_s1_20141101_20151201_v1_0.nc','land_ice_surface_easting_velocity',1,'x','y');
    elseif xys == 'y';
        [x y z] = grdread('greenland_iv_500m_s1_20141101_20151201_v1_0.nc','land_ice_surface_northing_velocity',1,'x','y');
    end
    z = z*365.25;
elseif data_set == 10
    if xys == 's'
        [x y z] = grdread('greenland_iv_500m_s1_20151223_20160331_v1_0.nc','land_ice_surface_velocity_magnitude',1,'x','y');
    elseif xys == 'x'
        [x y z] = grdread('greenland_iv_500m_s1_20151223_20160331_v1_0.nc','land_ice_surface_easting_velocity',1,'x','y');
    elseif xys == 'y';
        [x y z] = grdread('greenland_iv_500m_s1_20151223_20160331_v1_0.nc','land_ice_surface_northing_velocity',1,'x','y');
    end
    z = z*365.25;
elseif data_set == 11
    if xys == 's'
        [x y z] = grdread('greenland_iv_500m_s1_20161223_20170227_v1_0.nc','land_ice_surface_velocity_magnitude',1,'x','y');
    elseif xys == 'x'
        [x y z] = grdread('greenland_iv_500m_s1_20161223_20170227_v1_0.nc','land_ice_surface_easting_velocity',1,'x','y');
    elseif xys == 'y';
        [x y z] = grdread('greenland_iv_500m_s1_20161223_20170227_v1_0.nc','land_ice_surface_northing_velocity',1,'x','y');
    end
    z = z*365.25;
end

x = double(x);
y = double(y);
z = flipud(z);

xsteps = length(x);
ysteps = length(y);

if m0_km1_flag == 1
    x = x/1000;
    y = y/1000;
end

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
    elseif x1 == 'a',
        x1 = lxvalue;
        x2 = hxvalue;
        y1 = lyvalue;
        y2 = hyvalue;
    elseif x1 == '1';
        x1 = 0;
        x2 = hxvalue;
        y1 = -2e6;
        y2 = hyvalue;
    elseif x1 == '2';
        x1 = lxvalue;
        x2 = 0;
        y1 = -2e6;
        y2 = hyvalue;
    elseif x1 == '3';
        x1 = lxvalue;
        x2 = 0;
        y1 = lyvalue;
        y2 = -2e6;
    elseif x1 == '4';
        x1 = 0;
        x2 = hxvalue;
        y1 = lyvalue;
        y2 = -2e6;
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
y1index = max([y1index 1]);
y2index = min([y2index length(z(:,1))]);

x1index = max([x1index 1]);
x2index = min([x2index length(z(1,:))]);

lowx = x1index*celldim+lxvalue;
lowy = y1index*celldim+lyvalue;
highx = x2index*celldim+lxvalue;
highy = y2index*celldim+lyvalue;

xscale = lowx:celldim:highx;
yscale = lowy:celldim:highy;

%% Corrects for the fact that the y data is backward
if data_set < 9
temp = length(y)+1 - y1index;
y1index = length(y)+1 - y2index;
y2index = temp;
end


%%

plotdata = z(y1index:y2index,x1index:x2index);
if y(2) > y(1);
    plotdata = flipud(plotdata);
end

if plotter == 1
    val_im = imagesc(xscale,yscale,plotdata);
    
    if transparency > 0
        set(val_im,'AlphaData',transparency);
    end
    colormap(gmt_to_matlab_colormap(2))
    set(gca,'YDir','Normal')
    if xys == 's'
        caxis([0 150])
    else 
        caxis([-500 500])
    end
end


velname = data_set_opts{data_set};


y1 = xscale;
y2 = yscale;
y3 = plotdata;

end