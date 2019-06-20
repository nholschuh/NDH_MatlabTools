function fence(xaxis,yaxis,zaxis,data,transparent,resample_rate,colormap,clims);
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Plots a fence panel of radar / seismic data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% xaxis - vector of values for the x-coordinate of the radar data
% yaxis - vector of values for the y-coordinate of the radar data
% zaxis - vector of values for the z-axis of the fence
% data - matrix containing intensity values for the radar image
% [transparent] - value [0 1] indicating the transparency of the panel
% [resample_rate] - integer, downsamples the input matrix
% [colormap] - string for the colormap of choice. Only required if you want
%              to lock the colors to a specific colormap
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('resample_rate') == 0
    resample_rate = 1;
end
if resample_rate == 0
    resample_rate = 1;
end

if exist('transparent') == 0
    transparent = 0;
end

xaxis = xaxis(1:resample_rate:end);
yaxis = yaxis(1:resample_rate:end);
zaxis = zaxis(1:resample_rate:end);

data = data(1:resample_rate:end,1:resample_rate:end);
if exist('colormap') == 1
    if exist('clims') == 0
        data2 = colorlock_mat(data,colormap);
    else
    data2 = colorlock_mat(data,colormap,clims);
    end
else
    data2 = data;
end

[xm zm] = meshgrid(xaxis,zaxis);
[ym zm] = meshgrid(yaxis,zaxis);

a = surface(xm,ym,zm,data2);
alpha(a,1-transparent)
%set(a,'AlphaData',double([isnan(data2) == 0])*transparent);
shading interp

end