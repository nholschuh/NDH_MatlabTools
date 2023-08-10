function [x_slope_new,y_slope_new] = particletrace_gradient_preprocess(z,x_slope,y_slope)

x_slope_new = x_slope;
y_slope_new = y_slope;
mask = [x_slope == 0 & y_slope == 0];


fill_info = bwconncomp(mask);
sz = size(mask);

for i = 1:fill_info.NumObjects
    %%%%%%%%%% subset the original image to just a box containing a nan
    %%%%%%%%%% block
    [rs,cs] = ind2sub(sz,fill_info.PixelIdxList{i});
    if min(rs) == 1
        rshift = 1;
    else
        rshift = 2;
    end
    if min(cs) == 1
        cshift = 1;
    else
        cshift = 2;
    end
    
    rrange = max([min(rs)-1,1]):min([max(rs)+1,length(mask(:,1))]);
    crange = max([min(cs)-1,1]):min([max(cs)+1,length(mask(1,:))]);
    temp_im = z(rrange,crange);
    
    %%%%%%%%%% identify the cells that are immediately adjacent to the nan
    %%%%%%%%%% block
    edges_mask = zeros(length(rrange),length(crange));
    nan_inds = sub2ind(size(temp_im),rs-min(rs)+rshift,cs-min(cs)+cshift);
    edges_mask(nan_inds) = 1;
    
    edges_mask2 = smooth_ndh(edges_mask,3);
    fit_val_inds = find(edges_mask2 > 0 & edges_mask2 < 1 & edges_mask ~= 1);
    [fit_val_row,fit_val_col] = find(edges_mask2 > 0 & edges_mask2 < 1 & edges_mask ~= 1);
    
    %%%%%%%%%% Exctract the image values at the cells adjacent to the nan
    %%%%%%%%%% block
    fit_vals = temp_im(fit_val_inds);

    min_ind = find(min(fit_vals) == fit_vals);
    min_ind = min_ind(1);

    x_slope_new(fill_info.PixelIdxList{i}) = -1*(fit_val_col(min_ind) - (cs-min(cs)+rshift));
    y_slope_new(fill_info.PixelIdxList{i}) = -1*(fit_val_row(min_ind) - (rs-min(rs)+rshift));

end

[fill_single_pixels_r,fill_single_pixels_c] = find(x_slope_new == 0 & y_slope_new == 0);
for i = 1:length(fill_single_pixels_r);
    if fill_single_pixels_r(i) == 1
        rcenter = 1;
    else
        rcenter = 2;
    end
    if fill_single_pixels_c(i) == 1
        ccenter = 1;
    else
        ccenter = 2;
    end
    
    rrange = max([fill_single_pixels_r(i)-1,1]):min([fill_single_pixels_r(i)+1,length(mat(:,1))]);
    crange = max([fill_single_pixels_c(i)-1,1]):min([fill_single_pixels_c(i)+1,length(mat(1,:))]);
    temp_obj = new_mat(rrange,crange);
    temp_obj(rcenter,ccenter) = NaN;

    [fit_val_row,fit_val_col] = find(nanmin(temp_obj) == temp_obj);

    x_slope_new(fill_single_pixels_r(i),fill_single_pixels_c(i)) = -1*(ccenter-fit_val_col);
    y_slope_new(fill_single_pixels_r(i),fill_single_pixels_c(i)) = -1*(rcenter-fit_val_row);

end

