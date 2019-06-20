function plot_panel(x,y,top,bottom,color_val,transparency_val)

if length(x(1,:)) > 1
    x = x';
end

if length(y(1,:)) > 1
    y = y';
end

if length(top(1,:)) > 1
    top = top';
end

if length(bottom(1,:)) > 1
    bottom = bottom';
end

if exist('transparency_val') == 0
    transparency_val = 1;
end

aa = fill3([x; flipud(x); x(1)], [y; flipud(y); y(1)], [top; flipud(bottom); top(1)],color_val);
set(aa,'facealpha',transparency_val);

end