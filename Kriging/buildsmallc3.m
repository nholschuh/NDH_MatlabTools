function [c] = buildsmallc3(position,anisotropy,nu,range)

% this function calculates the covariances between the points used for
% interpolating and the interpolated point.
% works with anisotropy.
%
% usage:    [c] = buildsmallc3(position,anisotropy,nu,range)

% 6.6.2003 Rolf Sidler

% declaring variable
c = zeros(1,length(position));
for i = 1:length(position)
    % calculating lag with respect to anisotropy
    displace = sqrt((position(i,1))^2+anisotropy^2*(position(i,2))^2);
    % calculating covariance
    c(i) = covcalc(displace,nu,range);
end