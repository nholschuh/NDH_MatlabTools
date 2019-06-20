function [result lags] = convolution(series1,series2,xaxis1,xaxis2,plotter,method)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% Calculates the convoultion of series1 and series2 (if no series2 is
% included, it calculates the autocorrelation of series1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% series1 - The first series to be cross-correlated (or the series to be
% autocorrelated)
%
% series2 - The second series to be cross-correlated
%
% plotter - If set to 1, Plots the series sliding and xcorr values, if set
% to 2, records a video of the process
%
% method - if set to 1, selects all non-zero values of the autocorrelation.
% If set to 2, it keeps all values that fall in the positions of the
% original series 1.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('method') == 0
    method = 1;
end

if exist('series2') == 0
    series2 = series1;
else
    series2 = NaN2value(series2,0);
end

if exist('plotter') == 0
    plotter = 0;
end

if exist('xaxis1') == 0 % Sets up unit axes if none are specified
    xaxis1 = 0:length(series1(i,:))-1;
    xaxis2 = 0:length(series2)-1;
elseif isempty(xaxis1) == 1
    xaxis1 = 0:length(series1(i,:))-1;
    xaxis2 = 0:length(series2)-1;
end



dim = size(series2);
if find(dim == 1) == 1;
    series2 = fliplr(series2);
else
    series2 = flipud(series2);
end

xaxis2 = -xaxis2; % Reverse the X axis for convolution

[result lags] = correlation(series1,series2,xaxis1,xaxis2,plotter,method);

end
