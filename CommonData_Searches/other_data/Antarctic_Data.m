function [y1 y2 y3] = Antarctic_Data(data_set,x1,x2,y1,y2,plotter,m0_km1_flag)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This searches a given grid and extracts the values at provided points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data_set - Number corresponding to the data_set of interest
%               1 - Temperature (ERF_Interim)
%               2 - Temperature ( SeaRise)
%               3 - Accumulation Rate (Arthern et al. 2006 - from Albmap)
%               4 - Accumulation Rate (Van de Berg et al. - from Albmap)
%               5 - Geothermal Flux (Fox Maule et al. - from Albmap)
%               6 - Geothermal Flux (Shapiro and Ritzwoller - from Albmap)
%               7 - Firn Correction (from Albmap)
%               8 - Temperature (Annual Mean 2m Temperature - ERA Interim 2014)
%               9 - Temperature (Annual Mean Skin Temperature - ERA Interim 2014)
%              10 - Helm (2014) dh/dt
%              11 - McMillan (2014) dh/dt (cryosat-2)
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x - the x-axis for the imagery grid
% y - the y-axis for the imagery grid
% z - the colorvalues for the imagery grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('plotter') == 0
    plotter = 1;
end
if exist('m0_km1_flag') == 0
    m0_km1_flag = 0;
end
if exist('data_set') == 0
     data_set = listdlg('ListString',{...
              '1 - Temperature (ERF_Interim)',...
              '2 - Temperature ( SeaRise)',...
              '3 - Accumulation Rate (Arthern et al. 2006 - from Albmap)',...
              '4 - Accumulation Rate (Van de Berg et al. - from Albmap)',...
              '5 - Geothermal Flux (Fox Maule et al. - from Albmap)',...
              '6 - Geothermal Flux (Shapiro and Ritzwoller - from Albmap)',...
              '7 - Firn Correction (from Albmap)',...
              '8 - Temperature (Annual Mean 2m Temperature - ERA Interim 2014)',...
              '9 - Temperature (Annual Mean Skin Temperature - ERA Interim 2014)',...
             '10 - Helm (2014) dh/dt',...
             '11 - McMillan (2014) dh/dt (cryosat-2)'});       
end

if exist('x1') == 0
    x1 = 'a';
end


if data_set == 1
    [x y z] = grdread('Ant_Temperature_ERF_interim.nc');
elseif data_set == 2
    [x y z] = grdread('SeaRise_2010_AlbmapInfo.nc','temp',1,'x1','y1');
elseif data_set == 3
    [x y z] = grdread('SeaRise_2010_AlbmapInfo.nc','acca',1,'x1','y1');
elseif data_set == 4
    [x y z] = grdread('SeaRise_2010_AlbmapInfo.nc','accr',1,'x1','y1');
elseif data_set == 5
    [x y z] = grdread('SeaRise_2010_AlbmapInfo.nc','ghffm',1,'x1','y1');
elseif data_set == 6
    [x y z] = grdread('SeaRise_2010_AlbmapInfo.nc','ghfsr',1,'x1','y1');
elseif data_set == 7
    [x y z] = grdread('SeaRise_2010_AlbmapInfo.nc','firn',1,'x1','y1');
elseif data_set == 8
    [x y z] = grdread('Antarctic2mTemp_ERA_Int_2014.nc');
elseif data_set == 9
    [x y z] = grdread('AntarcticSkinTemp_ERA_Int_2014.nc');
elseif data_set == 10
    [x y z] = grdread('Helm_dhdt.grd');
elseif data_set == 11
    load('CS2_dzdt.mat')
    x = gridx;
    y = gridy; 
    z = AIS_dzdt;
    clearvars gridx gridy AISdzdt
elseif data_set == 12
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
    elseif x1 == '1';
        x1 = 0;
        x2 = hxvalue;
        y1 = 0;
        y2 = hyvalue;
        source_data = 1;
    elseif x1 == '2';
        x1 = lxvalue;
        x2 = 0;
        y1 = 0;
        y2 = hyvalue;
        source_data = 1;
    elseif x1 == '3';
        x1 = lxvalue;
        x2 = 0;
        y1 = lyvalue;
        y2 = 0;
        source_data = 1;
    elseif x1 == '4';
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
x1index = max([x1index 1]);
x2index = min([x2index length(x)]);
x2index = max([x2index 1]);

y1index = round((y1-lyvalue)/celldim)+1;
y2index = round((y2-lyvalue)/celldim);
y1index = max([y1index 1]);
y2index = min([y2index length(y)]);
y2index = max([y2index 1]);


lowx = x1index*celldim+lxvalue;
lowy = y1index*celldim+lyvalue;
highx = x2index*celldim+lxvalue;
highy = y2index*celldim+lyvalue;

xscale = lowx:celldim:highx;
yscale = lowy:celldim:highy;

%% Corrects for the fact that the y data is backward
temp = length(y) - y1index;
y1index = length(y) - y2index;
y2index = temp;

%%
z = flipud(z);
zdata = z(y1index:y2index,x1index:x2index);
zdata = flipud(zdata);

if plotter == 1
    imagesc(xscale,yscale,zdata)
    set(gca,'YDir','Normal')
end

y1 = xscale;
y2 = yscale;
y3 = zdata;





