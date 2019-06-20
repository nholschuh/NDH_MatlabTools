function [output,errorvariance] = vebyk(coord,dgrid,points,anisotropy,alpha,nu,range,crossv,verbose)

% Value Estimation BY Kriging:
% estimates values on a grid using ordinary kriging.
% 
% Parameters are ment as following:
% 'coord' = [x1 y1 value1;x2 y2 value2...]
% 'grid' = [xi yi] distances between two points on the interpolated grid
% 'points' is the number of points used for interpolation
% 'anisotropy' = (range x) / (range y)
% 'alpha' angle between axis and anisotropy in degrees
% 'nu' for the von karman covariance function.
% 'range' of the covariance function
% 'crossv' = 1 for crossvalidation; for normal operating set 'crossv' = 0
% 'verbose' = 1 for waitbar; = 0 without waitbar
%
% usage:    [output,errorvariance] = vebyk(coord,dgrid,points,anisotropy,alpha,nu,range,crossv,verbose)

% 12.6.2003 Rolf Sidler V 1.0

% calculating grid coordinates
maximum = max(coord);
minimum = min(coord);
ix = abs(round((maximum(1)-minimum(1))/dgrid(1)))+1;
iy = abs(round((maximum(2)-minimum(2))/dgrid(2)))+1;
grid = inputmatrix(ones(iy,ix),dgrid(1),dgrid(2));
grid(:,1) = grid(:,1) + minimum(1);
grid(:,2) = grid(:,2) + minimum(2);

% changing coordinate system for anisotropy on an angle different from 0
alpha = (2*pi)/360 * alpha;
coord = rotation(coord,alpha);
grid = rotation(grid,alpha);
grid = grid(:,1:2);
newgrid = zeros(length(grid),3);
errorvariance = zeros(length(grid),3);
errorvariance(:,1:2) = grid(:,1:2);
newgrid(:,1:2) = grid(:,1:2);

% waitbar
if verbose
    h = waitbar(0,'interpolating, please wait');
end
for i = 1:length(grid)
    % waitbar
    if verbose
        waitbar(i/length(grid),h)
    end
    % calculating the lags of the 'points' next points
    % (change to 'neighborhood2' to use points out of all four quadrants)
    % (change to 'neighborhood' to use simple search neighborhood)
    [values,position] = neighborhood(grid(i,1),grid(i,2),coord,points,crossv,anisotropy);
    % kriging
    [lambda,errorvariance(i,3)] = kriging3(position,anisotropy,nu,range);
    % calculating the interpolatet value
    newgrid(i,3) = sum(lambda(1:end-1) .* values');
end
% waitbar
if verbose
    close(h)
end

% changing coordinates back
output = rotation(newgrid,(-alpha));
errorvariance = rotation(errorvariance,(-alpha));