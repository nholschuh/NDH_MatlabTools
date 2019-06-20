function [output1 output2] = find_between(compvec,target);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% for a given value [target], this function finds the samples that lie on
% either side of the value for a monotonically increasing compvec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% target - the value you are seeking
% compvec - the vector containing sample boundaries in a series
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output - 2x1 vector with the indecies for the two adjacent samples
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


temp = find(compvec < target);
if length(temp) == 0
    output1 = 0;
else
    output1 = temp(end);
end

temp = find(compvec > target);
if length(temp) == 0
    output2 = length(compvec)
else
    output2 = temp(1);
end






