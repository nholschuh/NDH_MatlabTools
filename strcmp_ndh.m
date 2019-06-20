function [outval inds] = strcmp_ndh(stringlist,comparator,is_or_contains);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This is designed to take a string or cell array of strings, and determine
% if any of the provided strings contain the relevant comparator.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% stringlist - a string or cell array of strings that may contain the
%              provided comparison value
% comparator - the string to compare to the list
% is_or_contains - 0: must match comparator exactly, 1: contains comparator
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% outval - 1: at least one of the provided strings contains the comparison
%          string
% inds - the indecies of the strings that contain the value
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('is_or_contains') == 0
    is_or_contains = 0;
end

if isstr(stringlist) == 1
    stringlist = {stringlist};
end

for i = 1:length(stringlist)
    if is_or_contains == 0
        val(i) = strcmp(stringlist{i},comparator);
    else
        val(i) = str_contain(stringlist{i},comparator);
    end
end

outval = max(val);
inds = find(val == 1);
end