function [newC,c] = ordinary(C,c)

% appends mu to small c and ones to big C for ordynary kriging. that means
% the mean of the interpolated data is not expectet to be the same as the
% mean of the source data but all lambdas added up are equal to one.
%
% usage:    [C,c] = ordinary(C,c)

% Rolf Sidler 6.6.2003

c(end+1) = 1;

newC = ones(length(C)+1);
newC(1:end-1,1:end-1) = C;
newC(end,end) = 0;
