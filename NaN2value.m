function result = NaN2value(object,value)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% converts all NaN's to zeros in an object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% object - The matrix containing an assortment of values and NaNs
%
% value - The value you wish to replace NaNs.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


object(find(isnan(object) == 1)) = value;

result = object;