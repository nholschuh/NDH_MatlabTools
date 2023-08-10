function [new_mat,nanmask] = fill_localminima(mat,maxdepth,fill_type);


if 1
    %%
    DEM = GRIDobj(1:length(mat(1,:)),1:length(mat(:,1)),mat);
    DEM2 = DEM.fillsinks;
    new_mat = flipud(DEM2.Z);
    nanmask = [new_mat - mat ~= 0];
end



%%%%%%%%%%%%%%%%%%% This was my attempt to write this myself, but 
if 0
    minimum_cup = 0.1;
    max_gradient = 1;
    
    %%%%%%%% First we fill the minimum with nans
    new_mat = mat;
    for i = [minimum_cup,linspace(1,maxdepth,maxdepth)]
        mat_ind = imextendedmin(mat,i);
        new_mat(find(mat_ind)) = NaN;
    end
    
    
    
    %%%%%%%% Then we identify each nanblock, and fill it with either the mean
    %%%%%%%% of the surrounding area or a downward sloping value
    
    nanmask = isnan(new_mat);
    fill_info = bwconncomp(nanmask);
    
    sz = size(mat);
    
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
        
        rrange = max([min(rs)-1,1]):min([max(rs)+1,length(mat(:,1))]);
        crange = max([min(cs)-1,1]):min([max(cs)+1,length(mat(1,:))]);
        temp_im = mat(rrange,crange);
        
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
        
        %%%%%%%%%% Fill those cells with the mean value of the adjacent cells
        if fill_type == 0
            new_mat(fill_info.PixelIdxList{i}) = mean(fit_vals);
        end
        
        %%%%%%%%%% Fill with local sloping 2D surface
        if fill_type == 1
            
            if length(fit_val_row) > 3
                polymodel = polyfitn([fit_val_row,fit_val_col],fit_vals,1);
                fill_vals = polyvaln(polymodel,[rs-min(rs)+rshift,cs-min(cs)+cshift]);
                fill_vals = (fill_vals-min(fill_vals))/(max(fill_vals)-min(fill_vals))*max_gradient+mean(fit_vals);
                
            else
                fill_vals = mean(fit_vals);
            end
            
            new_mat(fill_info.PixelIdxList{i}) = fill_vals;
        end
    end
    
    [fill_single_pixels_r,fill_single_pixels_c] = find(isnan(new_mat));
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
        new_mat(fill_single_pixels_r(i),fill_single_pixels_c(i)) = nanmean(temp_obj,'all');
    end
end



