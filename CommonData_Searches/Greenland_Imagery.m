function [y1,y2,y3] = Greenland_Imagery(dataset,x1,x2,y1,y2,plotter,colorlock_flag,m0_km1_flag,w_velocity)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% Using a satellite imagery dataset of choice, this plots the data and
% locks its colormap (if selected) to allow for layered plotting of
% Antarctic datasets in Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% dataset - This flag determines which source dataset to read and
%%%               plot.
%%%                 1 - 400m resolution MODIS Imagery 
%%%                 2 - 400m resolution SAR Imagery 
%%%                 3 - 210m resolution ArcticDEM Hillshade
%%% x1 - This input can take on two types of values:
%%%         1) A number (either m or km, depending on a later flag) that
%%%            defines the left boundary of the domain of interest.
%%%         2) A single character string, that is used as shorthand to
%%%            define the domain of interest from the following:
%%%                 'w' - this is the western hemisphere
%%%                 'e' - this is the eastern hemisphere
%%%                 'a' - this is the whole continent (default)
%%%                 '1' - quadrant NE
%%%                 '2' - quadrant NW
%%%                 '3' - quadrant SW
%%%                 '4' - quadrant SE
%%% x2 - The right boundary of the domain (ignored if string for x1)
%%% y1 - The bottom boundary of the domain (ignored if string for x1)
%%% y2 - The top boundary of the domain (ignored if string for x1)
%%% plotter - flag that chooses whether or not to plot the image, or just
%%%           output the values to variable gi
%%% colorlock_flag - 0 does not lock the colormap (reduces the amount of
%%%                  memory required), 1 locks the colormap for potential
%%%                  overlays.
%%% m0_km1_glag - This sets whether your inputs (and outputs for gx/gy) are
%%%               in meters (0) or kilometers (1)
%%% w_velocity - Just image [0] or overlay velocity (1)
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% gx - the x-axis for the imagery grid
%%% gy - the y-axis for the imagery grid
%%% gi - the colorvalues for the imagery grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('plotter') == 0
    plotter = 1;
end
if exist('m0_km1_flag') == 0
    m0_km1_flag = 0;
end
    
if exist('colorlock_flag') == 0
    colorlock_flag = 1;
end

if exist('w_velocity') == 0
    w_velocity = 0;
end

if exist('dataset') ~= 1
    dataset = 1;
end
if length('dataset') == 0 | dataset == 0
    dataset = 1;
end

if dataset == 1
    [x y z] = grdread([OnePath,'Satellite_Mosaics\Greenland_MODIS\Greenland_400m.nc']);
elseif dataset == 2
    [x y z] = grdread([OnePath,'Satellite_Mosaics\Greenland_SAR_Mosaic\Measures_SarMosaic_2015.nc']);
elseif dataset == 3
    [x y z] = grdread([OnePath,'Satellite_Mosaics\ArcticDEM_Hillshade\ArcticDEM_Hillshade_210.nc']);
end



x = double(x);
y = double(y);

    
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
    elseif x1 == 'a',
        x1 = lxvalue;
        x2 = hxvalue;
        y1 = lyvalue;
        y2 = hyvalue;
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

x1index = max([round((x1-lxvalue)/celldim)+1 1]);
x2index = min([round((x2-lxvalue)/celldim) length(z(1,:))]);
y1index = max([round((y1-lyvalue)/celldim)+1 1]);
y2index = min([round((y2-lyvalue)/celldim) length(z(:,1))]);



lowx = x1index*celldim+lxvalue;
lowy = y1index*celldim+lyvalue;
highx = x2index*celldim+lxvalue;
highy = y2index*celldim+lyvalue;

xscale = lowx:celldim:highx;
yscale = lowy:celldim:highy;

%% Corrects for the fact that the y data is backward
temp = length(y) - y1index + 1;
y1index = length(y)+1 - y2index;
y2index = temp;

%%
z = flipud(z);
zdata = z(y1index:y2index,x1index:x2index);
zdata = flipud(zdata);

if plotter == 1
    imagesc(xscale,yscale,zdata)
    set(gca,'YDir','Normal')
    colormap(gray)
	if dataset == 1 
        caxis([13000 16500])
    elseif dataset == 2
        caxis([0 250])
    end

    if colorlock_flag == 1
        colorlock
    end
    hold all
    
    if w_velocity == 1
        [xv yv s] = G_Velocity(1,'s',x1,x2,y1,y2,0,m0_km1_flag);
        cs = gmt_to_matlab_colormap(2);
        s = colorlock_mat(s,cs,[0 200]);
        hh = imagesc(xv,yv,s);
        set(hh,'AlphaData',0.4)
    end    
end

y1 = xscale;
y2 = yscale;
y3 = zdata;

end
