function [results] = transect(line_params)
% Provides a graphical selection tool for the data. Points_lines=0 is
% points, 1=lines (default 0).

if exist('line_params') == 0
    default_lineparam_value = 1;
elseif isstr(line_params) == 0
    default_lineparam_value = 1;
end

temp = get(gca);

hold all

xmin = temp.XLim(1);
xmax = temp.XLim(2);
ymin = temp.YLim(1);
ymax = temp.YLim(2);

xrange = xmax-xmin;
yrange = ymax-ymin;

zoominfactor = .75;
zoomoutfactor = 1/zoominfactor;

output_storage = [];

i = 1;
start = 1;
temp = zeros(1,3);


while i == 1
    temp = zeros(1,3);
    [temp(1),temp(2),temp(3)] = ginput(1);
    output_storage(i,:) = temp;
    gs_ZoomIn_Function;
    gs_ZoomOut_Function;
    gs_Centering_Function;
    gs_Select_Undo_Function;
    i = i+1;
end
if i > 1
    while output_storage(i-1,3) ~= 113 & output_storage(i-1,3) ~= 81
        if output_storage(i-1,3) == 110
            output_storage(i-1,:) = [0 0 10];
            start = i;
        end
        
        temp = zeros(1,3);
        [temp(1),temp(2),temp(3)] = ginput(1);
        output_storage(i,:) = temp;
        
        gs_ZoomIn_Function;
        gs_ZoomOut_Function;
        gs_Centering_Function;
        gs_Select_Undo_Function;
        i = i+1;
    end
end
hold off
if output_storage(i-1,3) ~= 81
    close all
end

vertices = output_storage(1:(length(output_storage(:,1))-1),[1 2]);

graphics_temp = get(gca,'Children');
for i = 1:length(graphics_temp)
    if length(get(graphics_temp(i),'Type')) == 5
        if get(graphics_temp(i),'Type') == 'image'
            break
        end
    end
end

x_data = get(graphics_temp(i),'XData');
y_data = get(graphics_temp(i),'YData');
z_data = get(graphics_temp(i),'CData');
z_data = z_data(find_nearest(y_data,min(vertices(:,2))):find_nearest(y_data,max(vertices(:,2))),find_nearest(x_data,min(vertices(:,1))):find_nearest(x_data,max(vertices(:,1))));
x_data = x_data(find_nearest(x_data,min(vertices(:,1))):find_nearest(x_data,max(vertices(:,1))));
y_data = y_data(find_nearest(y_data,min(vertices(:,2))):find_nearest(y_data,max(vertices(:,2))));

x_ind = 1:length(x_data);
y_ind = 1:length(y_data);
[p,q] = meshgrid(x_data,y_data);
[p2,q2] = meshgrid(x_ind,y_ind);
x_pairs = [p(:) q(:) p2(:) q2(:)];



x_spacing = (x_data(2)-x_data(1))/3;

trans_line = line_fill(vertices,x_spacing,1);
dist_vals = distance_vector(trans_line(:,1),trans_line(:,2));

inds = [];
for i = 1:length(trans_line(:,1))
    trans_vals(i) = z_data(find_nearest(y_data,trans_line(i,2)),find_nearest(x_data,trans_line(i,1)));
end

entries = unique(trans_vals);
trans_vals2 = trans_vals(1);
dist_vals2 = dist_vals(1);
x_final = trans_line(1,1);
y_final = trans_line(1,2);

counter = 2;
for i = 1:length(entries)
    if isnan(entries(i)) == 0
    trans_vals2(counter) = trans_vals(find_nearest(dist_vals,mean(dist_vals(find(trans_vals == entries(i))))));
    dist_vals2(counter) = dist_vals(find_nearest(dist_vals,mean(dist_vals(find(trans_vals == entries(i))))));
    x_final(counter) = trans_line(find_nearest(dist_vals,mean(dist_vals(find(trans_vals == entries(i))))),1);
    y_final(counter) = trans_line(find_nearest(dist_vals,mean(dist_vals(find(trans_vals == entries(i))))),2);
    counter = counter+1;
    end
end
trans_vals2(end+1) = trans_vals(end);
dist_vals2(end+1) = dist_vals(end);
x_final(end+1) = trans_line(end,1);
y_final(end+1) = trans_line(end,2);

[dist_vals2 b] = sort(dist_vals2);
trans_vals2 = trans_vals2(b);
x_final = x_final(b);
y_final = y_final(b);

figure()
plot(dist_vals2,trans_vals2,'o-')

results = [x_final' y_final' trans_vals2' dist_vals2'];



end