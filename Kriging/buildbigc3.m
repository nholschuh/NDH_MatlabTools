function [C] = buildbigc3(position,anisotropy,nu,range)

% this function calculates the matrix containing the covariance values
% depending on the lags of the points used for interpolation
%
% usage:    [C] = buildbigc3(position,anisotropy,nu,range)

% 12.6.2003 Rolf Sidler

% declaring variable
C = zeros(length(position));
% calculating the distances between datapoints
[displace] = displacement3(position,anisotropy);
% calculating the covariance values depending on the lag between datapoints
for i = 1:length(position)
    for j = 1:i
        C(i,j) = covcalc(displace(i,j),nu,range);
        C(j,i) = C(i,j);
    end
end