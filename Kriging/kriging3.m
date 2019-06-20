function [lambda,errorvariance] = kriging3(position,anisotropy,nu,range)

% kriging is a algoritm for interpolation based on minimation of the
% variances. it is based on a model for the covariances. 'lags' is a vector containing the
% distances between the related values and the point to interpolate. kriging3 calculates
% the factors for the related values. the interpolated value is the sum of the related values
% each multiplied with lambda. 
% kriging3 is for use with an anisotropy factor
%
% usage: [lambda,errorvariance] = kriging3(position,anisotropy,nu,range)

% Rolf Sidler 5.6.03


% calculating the kriging factors
[C] = buildbigc3(position,anisotropy,nu,range);
[c] = buildsmallc3(position,anisotropy,nu,range);
% comment out next line to use simple kriging
[C,c] = ordinary(C,c);

[lambda] = C\c';
errorvariance = covcalc(0,nu,range)-sum(lambda.*c');