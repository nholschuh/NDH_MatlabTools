function [x y out_data im_hist] = grid_rgb(name_prefix,scale_type);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Reads in netcdfs produced from landsat geotiffs and converts them to a
% 3color matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% name_prefix - The input name to read in, can either be a string, or a
%               cell containing the prefix, and the three suffixes for RGB
% scale_type - [0] scale to the individual max or 1 the total max of vector
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x - the xaxis
% y - the yaxis
% data - the three dimensional matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if iscell(name_prefix) == 0
    if exist([name_prefix,'_R.nc']) ~= 0
        [x y r] = grdread([name_prefix,'_R.nc']);
        [x y g] = grdread([name_prefix,'_G.nc']);
        [x y b] = grdread([name_prefix,'_B.nc']);
    elseif exist([name_prefix,'_r.nc']) ~= 0
        [x y r] = grdread([name_prefix,'_r.nc']);
        [x y g] = grdread([name_prefix,'_g.nc']);
        [x y b] = grdread([name_prefix,'_b.nc']);
    end
else
    [x y r] = grdread([name_prefix{1},'_',name_prefix{2},'.nc']);
    [x y g] = grdread([name_prefix{1},'_',name_prefix{3},'.nc']);
    [x y b] = grdread([name_prefix{1},'_',name_prefix{4},'.nc']);
end

if exist('scale_type') == 0
    scale_type = 0;
end

if length(scale_type) == 1
    if scale_type == 0
        out_data(:,:,1) = r/max(max(r));
        out_data(:,:,2) = g/max(max(g));
        out_data(:,:,3) = b/max(max(b));
    elseif scale_type == 1
        
        total = max([max(max(r)) max(max(g)) max(max(b))]);
        
        out_data(:,:,1) = r/total;
        out_data(:,:,2) = g/total;
        out_data(:,:,3) = b/total;
    end
else
    temp_data(:,:,1) = r/max(max(r));
    temp_data(:,:,2) = g/max(max(g));
    temp_data(:,:,3) = b/max(max(b));
    
    out_data = rgb_scaling(temp_data,scale_type);
end

if nargout == 4
    for i = 1:3
        t1 = matrix_to_vector(out_data(:,:,1));
        [temp_counts temp_edges] = histcounts(t1,100,'Normalization','pdf');
        bin_center = (temp_edges(1:end-1) + temp_edges(2:end))/2;
        im_hist{i} = [bin_center' temp_counts'];
    end   
end


end


