function [nx ny output outindsx outindsy] = regrid(xaxis,yaxis,data,nx,ny,subsample_largergrid,interp_type);
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% This does a 2d interpolation for gridded data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% xaxis - The xaxis for the input data grid
% yaxis - The yaxis for the input data grid
% data - The input data grid
%
% There are several ways to use the following inputs:
% 1) nx - the desired xaxis for the output grid
%    ny - the desired yaxis for the output grid
%
% 2) nx - set to 0 - the output data will have equal grid spacing in the x
%         and y direction, set to be the finer grid spacing of the original data
%    ny - [];
%
% 2) nx - set to 1 - the data is assumed to be ice penetrating radar data,
%           and the source yaxis is assumed to be time in seconds. This is
%           immediately converted to depth, and the data are interpolated to an even
%           spacing in the x and y direction that is defined by spacing that is 4x
%           the nyquist frequency of the target data (sample rate provided in ny)
%    ny - center frequency of the radar data.
%
% subsample_largergrid - flag, 0 or 1, to indicate if you want the
%   regridded product to only take the samples of the larger grid that
%   overlap.
% interp_type - accepts 'spline', 'linear','nearest','next','cubic'
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
skipinterp = 0;

if min(size(xaxis)) > 1
    matflag = 1;
else
    matflag = 0;
end

if exist('subsample_largergrid') == 0
    subsample_largergrid = 0;
end

if exist('interp_type') == 0
    interp_type = 'linear';
end



%%%%%%%%%%%%%%%%%%%%%%%%%%% This only maters in interpolating radar data
%%%%%%%%%%%%%%%%%%%%%%%%%%% specifically
if length(nx) == 1
    % This automatically regrids the data to the finer spacing of the two
    % source spacings
    xstep = xaxis(2)-xaxis(1);
    ystep = yaxis(2)-yaxis(1);
    
    %%%%%%%%%%%%%%%%%%%%%%%% This was for interpolating radargrams,
    %%%%%%%%%%%%%%%%%%%%%%%% specifically.
    if nx == 1 & ystep < 1e-5
        cice_import
        ystep = ystep*cice/2;
    end
    
    if xstep > ystep;
        nx_temp = xaxis(1):ystep:xaxis(end);
        ny_temp = yaxis;
    elseif ystep > xstep
        nx_temp = xaxis;
        ny_temp = yaxis(1):xstep:yaxis(end);
    else
        skipinterp = 1;
        nx_temp = xaxis;
        ny_temp = yaxis;
    end
    
    % This regrids the data to 10x Nyquist frequency
    if nx == 1
        f = ny;
        cice_import
        %ystep = (1/f)/20
        ystep = (1/f)/20;
        ny_temp2 = yaxis(1):ystep:yaxis(end);
        nx_temp2 = xaxis(1):ystep:xaxis(end);
        
        if length(nx_temp2) > length(nx_temp) & length(ny_temp2) > length(ny_temp)
        else
           ny_temp = ny_temp2;
           nx_temp = nx_temp2;
        end
    end
    
    nx = nx_temp;
    ny = ny_temp;    
end

if skipinterp == 0
    
    if matflag == 0
        [y_0 x_0] = ndgrid(yaxis,xaxis);
        
        if subsample_largergrid == 1
            outindsx = find_nearest(nx,min(xaxis)):find_nearest(nx,max(xaxis));
            outindsy = find_nearest(ny,min(yaxis)):find_nearest(ny,max(yaxis));
            nx = nx(outindsx);
            ny = ny(outindsy);
        else
           outindsx = 1:length(nx);
           outindsy = 1:length(ny);
        end
        
        [interp_y interp_x] = ndgrid(ny,nx);
    else
        y_0 = yaxis;
        x_0 = xaxis;
        interp_y = ny;
        interp_x = nx;
        
        outindsx = NaN;
        outindsy = NaN;
    end
    
    A = griddedInterpolant(y_0,x_0,data,interp_type);
    output = A(interp_y,interp_x);
    if min(min(isnan(output))) == 1
        A = griddedInterpolant(y_0,x_0,data,'linear');
        output = A(interp_y,interp_x);
    end
else
    output = data;
end
    
end