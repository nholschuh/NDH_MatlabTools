function [gx,gy,gi] = Antarctic_Imagery(dataset,x1,x2,y1,y2,plotter,colorlock_flag,m0_km1_flag,w_velocity)
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% Using a satellite imagery dataset of choice, this plots the data and
% locks its colormap (if selected) to allow for layered plotting of
% Antarctic datasets in Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% dataset - This flag determines which source dataset to read and
%%%               plot. 
%%%                 (0) - MODIS (750m)
%%%                 (1) - MODIS (125m)
%%%                 (3) - Radarsat mosaic of Antarctica (500m)
%%%                 (3) - Radarsat mosaic of Antarctica (200m)
%%%                 (4) - REMA Hillshade
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
%%% m0_km1_flag - This sets whether your inputs (and outputs for gx/gy) are
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

if exist('x1') == 0
    x1 = 'a';
end

if exist('m0_km1_flag') == 0
    m0_km1_flag = 0;
end
if m0_km1_flag == 1
    scaler = 1/1000;
else
    scaler = 1;
end

if exist('w_velocity') == 0
    w_velocity = 0;
end

if exist('dataset') ~= 1
    dataset = 0;
end
if length(dataset) == 0
    dataset = 0;
end


lxvalue = -3174075*scaler;
lyvalue = -2816300*scaler;
hxvalue = 2867175*scaler;
hyvalue = 2405950*scaler;

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
        dataset = 1;
    elseif x1 == '2';
        x1 = lxvalue;
        x2 = 0;
        y1 = 0;
        y2 = hyvalue;
        dataset = 1;
    elseif x1 == '3';
        x1 = lxvalue;
        x2 = 0;
        y1 = lyvalue;
        y2 = 0;
        dataset = 1;
    elseif x1 == '4';
        x1 = 0;
        x2 = hxvalue;
        y1 = lyvalue;
        y2 = 0;
        dataset = 1;
    else
        x1 = x1;
        %%%% Supplies default values if nothing else is provided
        if exist('x2','var') == 0
            x2 = hxvalue;
        else
            x2 = x2;
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
end

%%%%%%%%%%%%%%%%%%%%%%% This sets the remaining defaults
if exist('plotter') == 0
    plotter = 1;
end
if exist('colorlock_flag') == 0
    colorlock_flag = 1;
end
if exist('dataset') == 0
    dataset = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%% Load in the appropriate data
if dataset == 0
    [x y z] = grdread([OnePath,'Satellite_Mosaics/Antarctica_Modis_MOA/moa750.grd']);
    %z(find(z == 0)) = 255;
elseif dataset == 1
    files_inc = [];
    z = [];
    if min([x1 x2]) < 0 & max([y1 y2]) > 0
        [xt1 yt2 zt1] = grdread([OnePath,'Satellite_Mosaics/Antarctica_Modis_MOA/moa125_ul.nc']);
        z = zt1;
    end
    if min([x1 x2]) < 0 & min([y1 y2]) < 0
        [xt1 yt1 zt2] = grdread([OnePath,'Satellite_Mosaics/Antarctica_Modis_MOA/moa125_ll.nc']);
        z = [zt2; z];
    end
    if max([x1 x2]) > 0 & max([y1 y2]) > 0
        sz = size(z);
        [xt2 yt2 zt3] = grdread([OnePath,'Satellite_Mosaics/Antarctica_Modis_MOA/moa125_ur.nc']);
        if sz(1) > sz(2);
            z = [z [zeros(size(zt3)); zt3]];
        else
            z = [z zt3];
        end
    end             
    if max([x1 x2]) > 0 & min([y1 y2]) < 0
        sz = size(z);
        [xt2 yt1 zt4] = grdread([OnePath,'Satellite_Mosaics\Antarctica_Modis_MOA\moa125_lr.nc']);
        files_inc = [files_inc 4];
        if sz(1) > yt1
            z(1:length(yt1),end-length(xt2)+1:end) = zt4;
        else
            z = [z zt4];            
        end
    end
    if exist('xt1') == 0; xt1 = []; end; if exist('yt1') == 0; yt1 = []; end;
    if exist('xt2') == 0; xt2 = []; end; if exist('yt2') == 0; yt2 = []; end;
    x = [xt1 xt2];
    y = [yt1 yt2];
    clearvars xt* yt* zt*
elseif dataset == 2
    [x y z] = grdread([OnePath,'Satellite_Mosaics\Antarctica_Radarsat_RAMP\amm500.grd']);
elseif dataset == 3
    [x y z] = grdread([OnePath,'Satellite_Mosaics\Antarctica_Radarsat_RAMP\amm200.grd']);    
elseif dataset == 4
    [x y z] = grdread([OnePath,'/Satellite_Mosaics/REMA_Hillshade/REMA_200m_hillshade.nc']); 
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

x1index = max([round((x1-min(x))/celldim)+1 1]);
x2index = min([round((x2-min(x))/celldim) length(z(1,:))]);
y1index = max([round((y1-min(y))/celldim)+1 1]);
y2index = min([round((y2-min(y))/celldim) length(z(:,1))]);


lowx = x1index*celldim+min(x);
lowy = y1index*celldim+min(y);
highx = x2index*celldim+min(x);
highy = y2index*celldim+min(y);

xscale = lowx:celldim:highx;
yscale = lowy:celldim:highy;

%% Corrects for the fact that the y data is backward
temp = length(y) - y1index + 1;
y1index = length(y) - y2index + 1;
y2index = temp;

%%

sz = size(z);
zdata = z(sz(1)-fliplr(y1index:y2index)+1,x1index:x2index);




if plotter == 1

    
    
    if dataset == 0 | dataset == 1
        clims = ([-50 200]);
    elseif dataset == 2 | dataset == 3 | dataset == 4
        clims = ([0 255]);
    end
    colormap(gray);
    
    if colorlock_flag == 1
        %zdata(find(zdata == 0)) = 255;
        zdata2 = colorlock_mat(zdata,'gray',clims);
    else
        zdata2 = zdata;
    end
    
    imagesc(xscale,yscale,zdata2)
    set(gca,'YDir','Normal')
    hold all
    
    
    if w_velocity == 1
        [xv yv s] = A_Velocity(3,'s',x1,x2,y1,y2,0,m0_km1_flag);
        cs = gmt_to_matlab_colormap(2);
        %cs = magma();
        s2 = colorlock_mat(s,cs,[0 400]);
        hh = imagesc(xv,yv,s2);
        set(hh,'AlphaData',~isnan(s)*0.2)
    end
    
end

gx = xscale;
gy = yscale;
gi = zdata;

end

