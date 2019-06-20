function ticker(value_options,current_step,label,fill_color,width,h_sep);

cs = get(gcf,'Children');
px = get(gcf,'Position');

if mod(current_step,1) == 0
    ind_flag = 1;
else
    ind_flag = 0;
end

sep_flag = 0;
for i = 1:length(cs)
    if length(get(cs(i),'Type')) == 8
        if get(cs(i),'Type') == 'colorbar'
            sep_flag = 1;
        end
    end
end

colormap_mat = ones(length(value_options)-1,3);
min_caxis = [min(value_options)];
color_vals = [value_options(2:end)];


if current_step > 1
    if ind_flag == 0;
        color_ind = find_nearest(value_options,perturb_size);
    else
        color_ind = current_step;
    end
else
     color_ind = 0;
end

colormap_mat(1:color_ind,:) = repmat(fill_color,color_ind,1);

ax2 = axes();
axis off

cb2 = colorbar();
colormap(cb2,colormap_mat);
ylabel(cb2,label);

c_size = get(cb2,'Position');

if exist('h_sep') == 0
    h_sep = 80;
end

if sep_flag == 1
    c_size(1) = c_size(1)+h_sep/px(3);
end

if exist('width') == 1
    c_size(3) = width/px(3);
end

set(cb2,'Position',c_size);
caxis([min(value_options) max(value_options)]);
end











