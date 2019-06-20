function [above below] = inds_above(mat_in,row_inds);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This takes an input matrix, and identifies the single value (ie, not rows
% and columns) index for cells above and below the target row for each
% column.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% mat_in - the input matrix (to get the size)
% row_inds - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% above - indecies above and equal to the provided rows
% below - indecies below the provided rows
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%



ss = size(mat_in);
total_ind = 1:prod(ss);
split_inds = row_inds+ss(1)*((1:ss(2))-1);
starts = ss(1)*((1:ss(2))-1)+1;
ends = ss(1)*(ss(1));

above = [];
for i = 1:length(split_inds);
    above = [above starts(i):split_inds(i)];
end

below = total_ind;
below(above) = [];

end















