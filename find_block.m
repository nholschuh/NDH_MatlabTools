function indrange = find_block(inputvec,ind);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This identifies indecies correspnding to a block of identical values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% inputvec - the vector of interest containing the blocks
% ind - an index within the target blcok
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% indrange - The range of indecies corresponding to the block
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%% Find values equal to the example within the block
val = inputvec(ind);
indopts = find(inputvec == inputvec(ind));

%%% Find which index of all the equivalent options is the one corresponding
%%% to the source block
blockind = find(indopts == ind);

%%% Find gaps in the blocks
diffopts = find(diff(indopts) > 1);


%%% Deal with the case where all values that match the input index are
%%% continuous
if isempty(diffopts) == 1
    sval = indopts(1);
    endval = indopts(end);    
else
    %%% Find the first gap in blocks that is comes after the target index
    above = find(diffopts >= blockind);
    
    %%% Use this to derive the start and end indecies of the block
    if length(above) == 0
        sval = indopts(diffopts(end))+1;
        endval = length(inputvec);
    else
        endval = indopts(diffopts(above(1)));
        if above(1) == 1
            sval = 1;
        elseif above
            sval = indopts(diffopts(above(1)-1))+1;
        end
    end
end


indrange = sval:endval;


