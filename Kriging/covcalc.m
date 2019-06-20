function [covariance] = covcalc(lag,nu,a)

% this function contains the model for the covariance function. the
% covariance is only depending on the lag i.e the displacement of two data
% points.
%
% usage:    [covariance] = covcalc(lag,nu,a)

% 6.6.2003 Rolf Sidler

% parameters
C0 = 1 ;
varianz = 1;

% exponential model
% covariance = C0 .* exp((-3.*lag)./a);

% spherical model
% covariance = C0*(1-3/2*(lag/a)+1/2*(lag/a)^3);

% power functions
% alpha = 1.5;
% covariance = C0 * (1-abs(lag)^alpha);
 
% von Karman model
if lag == 0
    covariance = 1;
else
    covariance = (varianz/(2^(nu-1)*gamma(nu))).*(lag./a).^nu .* besselk(nu,(lag./a));
end