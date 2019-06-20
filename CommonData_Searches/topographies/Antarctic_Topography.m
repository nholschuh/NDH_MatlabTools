function [y1 y2 y3] = Antarctic_Topography(data_set,x1,x2,y1,y2,plotter,m0_km1_flag)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This loads into memory subsets of Antarctic Topographic data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data_set - Number corresponding to the data_set of interest
%               1 - Bedmap2 Bed
%               2 - Bedmap2 Surface
%               3 - Bedmap2 thickness
%               4 - Geoid to WGS84 Correction [These values should be added
%                                              to geoid data (like bedmap2)
%                                              to bring the data in line
%                                              with the WGS84 reference
%                                              (like MCoRDS)]
%               5 - Cryosat2 Surface (Helm 2014 - WGS84)
%               6 - Albmap Bed
%               7 - Bedmap1 Bed
%               8 - Ground Mask
%               9 - Ben Smith Surface Elevation (WGS84)
%               10 - Morlighem Mass Con Antarctica Bed
%               11 - REMA DEM of Antarctica (200m)
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
     data_set = listdlg('ListString',{'1 - Bedmap2 Bed' ,...
        '2 - Bedmap2 Surface', ...
        '3 - Bedmap2 thickness', ...
        '4 - Geoid to WGS84 Correction', ...
        '5 - Cryosat2 Surface (Holt 2014)', ...
        '6 - Albmap Bed', ...
        '7 - Bedmap1 Bed', ...
        '8 - Ground Mask', ...
        '9 - BenSmith Surface', ...
        '10 - MassCon', ...
        '11 - REMA Surface Elevation'},'PromptString',sprintf(['Dataset Options:\n-----------------------------']));
        
end

if exist('x1') == 0
    x1 = 'a';
end


if data_set == 1
    [x y z] = grdread('Bedmap2_bed.grd');
elseif data_set == 2
    [x y z] = grdread('Bedmap2_surface.grd');
elseif data_set == 3
    [x y z] = grdread('Bedmap2_thickness.grd');
elseif data_set == 4
    [x y z] = grdread('g104c_geoid_to_WGS84.nc');
elseif data_set == 5
    [x y z] = grdread('AntarcticSurface_Cryosat2.nc');
elseif data_set == 6
    [x y z] = grdread('ALBMAP_Bed.grd');
elseif data_set == 7    
    [x y z] = grdread('bedmap1.nc');
elseif data_set == 8    
    load moa_groundedmask.mat
    x = ix;
    y = iy;
    z = gl_mask;
    clearvars ix iy gl_mask
elseif data_set == 9   
    [x y z] = grdread('BenSurface.nc');
elseif data_set == 10   
    [x y z] = grdread('MC_Bed.nc');
elseif data_set == 11   
    [x y z] = grdread('REMA_200m_dem.nc');
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
temp = length(y) - y1index + 1;
y1index = length(y) - y2index + 1;
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





