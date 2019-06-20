function output = ReplacePoints_Grid(points,gridx,gridy,grid_mask,replace_val)

[fixind_x fixind_y] = find(grid_mask == 1);

dx = gridx(2)-gridx(1);
dy = gridy(2)-gridy(1);

xind = (points(:,1)-min(gridx))/dx;
yind = (points(:,2)-min(gridy))/dy;

xind(find(xind < 0 | xind > length(gridx))) = fixind_x(1);
yind(find(yind < 0 | yind > length(gridy))) = fixind_y(1);

mask_ind = yind+(xind - 1)*length(yind);
replace_ind = grid_mask(mask_ind);

output = points;
output(replace_ind) = replace_val;

end






