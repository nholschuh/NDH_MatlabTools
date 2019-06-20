function handle_out = plot_colorline(x,y,c,method,linewidth,transp_val);

xs = size(x);
ys = size(y);
if ischar(c) == 1
    c2 = color_call(c)/255;
    if xs(2) < xs(1);
        c = zeros(size(x'));
    else
        c = zeros(size(x));
    end
else
    c2 = 'interp';
end

cs = size(c);


if xs(2) < xs(1);
    x = x';
end

if ys(2) < ys(1);
    y = y';
end

if cs(2) < cs(1);
    c = c';
end

if exist('linewidth') == 0
    linewidth = 2;
end

if exist('transp_val') == 0
    transp_val = 0;
end

%%%%%%%%%%%%% There are two methods available - Method one plots the z
%%%%%%%%%%%%% value included (so it can be selected by the plot), while
%%%%%%%%%%%%% method two plots the z value as zero

if exist('method') == 0
    method = 2;
end
if method == 0
    method = 2;
end

if method == 1
    handle_out = surface([x;x],[y;y],[c;c],[c;c],...
        'facecol','no',...
        'edgecol',c2,...
        'linew',linewidth);
elseif method == 2
    handle_out = surface([x;x],[y;y],[zeros(size(x));zeros(size(x))],[c;c],...
        'facecol','no',...
        'edgecol',c2,...
        'linew',linewidth);    
    alpha(handle_out,transp_val);
end

end

