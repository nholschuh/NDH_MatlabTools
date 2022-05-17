function [outval inds] = strcmp_ndh(stringlist,comparatorlist,is_or_contains);
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
    listtype = 2;
    if isstr(comparatorlist)
        comparatorlist = {comparatorlist};
    end
elseif isstr(comparatorlist)
    comparatorlist = {comparatorlist};
    listtype = 1;
else
    listtype = 0;
end


if listtype == 1
    for i = 1:length(stringlist)
        if is_or_contains == 0
            val(i) = strcmp(stringlist{i},comparatorlist{1});
        else
            val(i) = str_contain(stringlist{i},comparatorlist{1});
        end
    end
elseif listtype == 2
    for i = 1:length(comparatorlist)
        if is_or_contains == 0
            val(i) = strcmp(stringlist{1},comparatorlist{i});
        else
            val(i) = str_contain(stringlist{1},comparatorlist{i});
        end
    end    
elseif listtype == 0
    error('Only one of the two entries (stringlist or comparatorlist) can include multiple values')
end

outval = max(val);
inds = find(val == 1);
end