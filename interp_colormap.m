function nc = interp_colormap(cmap,fill_num,truncate_high,truncate_low);


if exist('truncate_high') == 0
    truncate_high = 0;
end
if exist('truncate_low') == 0
    truncate_low = 0;
end

cmap = cmap(1+truncate_low:end-truncate_high,:);

d_Axis = 1:length(cmap(:,1));

nd_Axis = 1:1/fill_num:length(cmap(:,1));

nc(:,1) = interp1(d_Axis,cmap(:,1),nd_Axis);
nc(:,2) = interp1(d_Axis,cmap(:,2),nd_Axis);
nc(:,3) = interp1(d_Axis,cmap(:,3),nd_Axis);


end