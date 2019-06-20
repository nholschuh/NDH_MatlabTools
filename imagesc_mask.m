function imagesc_mask(x,y,grid_mask,color)

if isstr('color') == 1
    color = color_call(color);
end


    %%%%%%%% This sets up the blue ocean
    true_mask_temp(:,:,1) = ones(size(grid_mask))*color(1);
    true_mask_temp(:,:,2) = ones(size(grid_mask))*color(2);
    true_mask_temp(:,:,3) = ones(size(grid_mask))*color(3);
    
    
    hhhhhh = imagesc(x,y,true_mask_temp);
    set(hhhhhh,'AlphaData',grid_mask)
end