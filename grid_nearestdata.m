function dist_grid = grid_nearestdata(data_coord,gridx,gridy,max_nearness);
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% This function finds (roughly) how far away the nearest data is to a cell
% in a grid, in order to filter out bad cells from a grid of choice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% data_coord - an Nx2 matrix containing x-y coordinates for the data
% gridx - the x axis for the grid to search
% gridy - the y axis for the grid to search
% max_nearness - the number of cells adjacent to search for the maximum
% distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dx = abs(gridx(2)-gridx(1));

if exist('max_nearness') == 0
    max_nearness = 31;
end


if min(size(gridx)) == 1
    init_coordmat = zeros(length(gridy),length(gridx));
    final_coordmat = zeros(length(gridy),length(gridx));
else
    init_coordmat = zeros(size(gridx));
    final_coordmat = zeros(size(gridx));
end

[trash trash gridinds] = matsearch(data_coord,gridx,gridy,init_coordmat);

gridinds2 = removeNaN(gridinds);

for i = 1:length(gridinds2)
    init_coordmat(gridinds2(i,1),gridinds2(i,2)) = 1;
    final_coordmat(gridinds2(i,1),gridinds2(i,2)) = 1;
end

for i = 1:(max_nearness-1)/2;
    outmat = smooth_ndh(init_coordmat,(i-1)*2+1,2);
    next_inds = find(outmat > 0 & final_coordmat == 0);
    final_coordmat(next_inds) = i+1;
end

final_coordmat(find(final_coordmat == 0)) = Inf;

dist_grid = final_coordmat;

end
    
    





