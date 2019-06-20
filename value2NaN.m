function result = value2NaN(object,value)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% converts all of a given value to NaNs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% object - The matrix containing an assortment of values and NaNs
%
% value - The value you wish to replace with NaNs.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


object(find(object == value)) = NaN;

result = object;
end