function [y1 y2 y3] = Greenland_Topography(data_set,x1,x2,y1,y2,plotter,m0_km1_flag)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This loads into memory subsets of Antarctic Topographic data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data_set - Number corresponding to the data_set of interest
%               1 - Bed (Bamber)
%               2 - Surface (Bamber)
%               3 - Thickness (Bamber)
%               4 - MassCon Bed (Mouginot)
%               5 - MassCon Surface (Mouginot)
%               6 - MassCon Thickness (Mouginot)
%               7 - geoid (Mouginot)
%               8 - Surface (Worldview - 210m)
%               9 - Surface (Full Resolution [30m])
%               10 - Grounded_Mask (Mouginot)
%               11 - Bed Uncertainty (Mouginot)
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x - the x-axis for the imagery grid
% y - the y-axis for the imagery grid
% z - the colorvalues for the imagery grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('data_set') == 0
     data_set = listdlg('ListString',{'1 - Bed (Bamber)' ,...
        '2 - Surface (Bamber)', ...
        '3 - Thickness (Bamber)', ...
        '4 - MassCon Bed (Mouginot)', ...
        '5 - MassCon Surface (Mouginot)', ...
        '6 - MassCon Thickness (Mouginot)', ...
        '7 - geoid (Mouginot)', ...
        '8 - Surface (Worldview - 210m)', ...
        '9 - Surface (Full Resolution [30m])'},'PromptString',sprintf(['Dataset Options:\n-----------------------------']))
end
if exist('plotter') == 0
    plotter = 1;
end
if exist('m0_km1_flag') == 0
    m0_km1_flag = 0;
end
if exist('data_set') == 0
    data_set = 1;
end
if exist('x1') == 0
    x1 = 'a';
end


if data_set == 1
    [x y z] = grdread('GreenlandBed_Bamber.nc');
    z = flipud(z);
elseif data_set == 2
    [x y z] = grdread('GreenlandSurface_Bamber.nc');
    z = flipud(z);
elseif data_set == 3
    [x y z] = grdread('GreenlandThick_Bamber.nc');
    z = flipud(z);
elseif data_set == 4
    % Old Version
    %[x y z] = grdread('MCdataset-2015-04-27.nc','bed',1,'x','y');
    [x y z] = grdread('BedMachineGreenland-2017-09-20.nc','bed',1,'x','y');
elseif data_set == 5
    % Old Version
    %[x y z] = grdread('MCdataset-2015-04-27.nc','surface',1,'x','y');
    [x y z] = grdread('BedMachineGreenland-2017-09-20.nc','surface',1,'x','y');
elseif data_set == 6
    % Old Version
    %[x y z] = grdread('MCdataset-2015-04-27.nc','thickness',1,'x','y');
    [x y z] = grdread('BedMachineGreenland-2017-09-20.nc','thickness',1,'x','y');
elseif data_set == 7    
    [x y z] = grdread('MCdataset-2015-04-27.nc','geoid',1,'x','y');
elseif data_set == 8    
    [x y z] = grdread('WV_Greenland_Surf_210m.nc');
    z = flipud(z);
elseif data_set == 9
    load tile_info.mat
    file_inds = find(nc_xlims(:,2) > x1 & nc_xlims(:,1) < x2 & nc_ylims(:,2) > y1 & nc_ylims(:,1) < y2);
    x = min(nc_xlims(file_inds,1)):dx:max(nc_xlims(file_inds,2));
    y = min(nc_ylims(file_inds,1)):dy:max(nc_ylims(file_inds,2));
    z = zeros(length(y),length(x));
    for i = 1:length(file_inds);
        [xt yt zt] = grdread(files(file_inds(i)).name);
        fillx_ind = find(min(xt) == x):find(max(xt) == x);
        filly_ind = find(min(yt) == y):find(max(yt) == y);
        z(filly_ind,fillx_ind) = zt;
    end
    z = flipud(z);
    clearvars file_inds nc_xlims nc_ylims sizes files fillx_ind filly_ind    
elseif data_set == 10
%     %%%%%%%%%%%%%%%%%%%%% This creates the mask if it doesn't already exist
%     [x y zb] = grdread('BedMachineGreenland-2017-09-20.nc','bed',1,'x','y');
%     [x y zs] = grdread('BedMachineGreenland-2017-09-20.nc','surface',1,'x','y');
%     [x y zt] = grdread('BedMachineGreenland-2017-09-20.nc','thickness',1,'x','y');
%     
%     z = double([zs-zt] == zb);
%     imagesc(z);
%     cut_triangle = graphical_selection(1);
%     cols = 1:round(max(cut_triangle(:,1)));
%     ind_below = round(interp1(cut_triangle(:,1),cut_triangle(:,2),cols));
%     for i = 1:length(cols)
%         if ind_below(i) > 0
%         z(1:ind_below(i),i) = 0;
%         end
%     end
%     grdwrite(x,y,z,'BedMachine_GroundMask.nc');
    
    [x y z] = grdread('BedMachine_GroundMask.nc');
elseif data_set == 11
        [x y z] = grdread('MCdataset-2015-04-27.nc','errbed',1,'x','y');
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

if y(2) > y(1)
    flipy_flag = 0;
else
    flipy_flag = 1;
end


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
temp = length(y) - y1index+1;
y1index = length(y) - y2index+1;
y2index = temp;

zdata = z(y1index:y2index,x1index:x2index);


    zdata = flipud(zdata);


if plotter == 1
    imagesc(xscale,yscale,zdata)
    set(gca,'YDir','Normal')
end

y1 = xscale;
y2 = yscale;
y3 = zdata;





