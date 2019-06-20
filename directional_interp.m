function [x_out y_out z_out] = directional_interp(data_2d,zvals,orientation,d_grid)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Performs an interpolation with a dominant and secondary direction, to
% produce the final gridded product
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% data_2d - the x and y coordinates (in an Nx2 matrix) for the z values
% zvals - the z values
% orientation - a vector containing the primary orientation for
%               interpolation
% d_grid - the spacing for the output grid
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x_out - the x coordinates of the mesh
% y_out - the y coordinates of the mesh
% z_out - the z coordinates corresponding with the mesh
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%



r_data = points_rotate(data_2d,-orientation+90);
gx = min(r_data(:,1)):d_grid:max(r_data(:,1));
gy = min(r_data(:,2)):d_grid:max(r_data(:,2));

window = 0.3;
left_cutoffs = [gx-window*d_grid];
right_cutoffs = [gx+window*d_grid];
[X Y] = meshgrid(gx,gy);

z_out = ones(size(X))*NaN;

for i = 1:length(X(1,:))
    data_inds = find(r_data(:,1) > left_cutoffs(i) & r_data(:,1) < right_cutoffs(i));
    temp_data = [r_data(data_inds,1:2)];

    temp_data = [r_data(data_inds,2) zvals(data_inds)];
    temp_data(:,1) = round((temp_data(:,1)-min(gy))/d_grid);
    [yinds keep_inds] = remove_duplicates(temp_data(:,1));
    tempz = temp_data(keep_inds,2);

    if length(find(isnan(tempz) == 0)) > 1 & max(yinds) - min(yinds) > 50
        z_out(:,i) = interp1(yinds,tempz,1:length(X(:,1)),'spline');
        outmax = find(z_out(:,i) > max(tempz));
        outmin = find(z_out(:,i) < min(tempz));
        z_out(outmax,i) = max(tempz);
        z_out(outmin,i) = min(tempz);
    end
end

%%%%% This does a secondary interpolation to fix holes in the data
for i = 1:length(z_out(:,1))
    z_out(i,:) = interpNaN(z_out(i,:));
end


out_grid(:,:,1) = X;
out_grid(:,:,2) = Y;

out_grid = points_rotate(out_grid,orientation-90);
x_out = squeeze(out_grid(:,:,1));
y_out = squeeze(out_grid(:,:,2));

end





