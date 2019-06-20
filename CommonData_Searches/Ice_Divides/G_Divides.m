function output = G_Divides(ds,divides,plotter);

data = dlmread('Greenland_Divides.txt',' ',7,0);
rm_col = [];
for i = 1:length(data(1,:))
    if max(data(:,i)) == 0
        rm_col = [rm_col i];
    end
end
data(:,rm_col) = [];

if exist('ds') == 0
    ds = 10;
end
if exist('plotter') == 0
    plotter = 1;
end

data = data(1:ds:end,:);

divide_num = data(:,1);
divide_options = remove_duplicates(divide_num);

[x y] = polarstereo_fwd(data(:,2),data(:,3));


if exist('divides') == 0
    divides = divide_options;
elseif divides == 0
    divides = divide_options;
else
    divides = divide_options(divides);
end


if length(divides) == 1 && divides == 0
    colors = jet(length(divide_options));
    a = figure(10);
    for i = 1:length(divide_options)
        temp_ind = find(data(:,1) == divide_options(i));
        plot(x(temp_ind(1):50:temp_ind(end)),y(temp_ind(1):50:temp_ind(end)),'o','Color',colors(i,:),'MarkerFaceColor',colors(i,:),'MarkerSize',1);
        hold all
    end
    colormap(jet(length(divide_options)))
    caxis([1 length(divide_options)])
    colorbar
    axis square
    pause(1)
    divide_select = inputdlg('Divides? (separate with spaces)');
    divide_select = strsplit(divide_select{1},' ');
    divides = [];
    for i = 1:length(divide_select)
        divides = [divides divide_options(eval(divide_select{i}))];
    end
    close(a)
end


x_out = [];
y_out = [];

for i = 1:length(divides)
    temp_ind = find(divide_num == divides(i));
    y_out = [y_out; NaN; y(temp_ind)];
    x_out = [x_out; NaN; x(temp_ind)];
    if plotter == 1
        plot(x(temp_ind),y(temp_ind),'o','Color',[0.6 0.6 0.6],'MarkerSize',1);
        hold all
    end
end

if plotter == 1
    groundingline(6);
    axis equal
end


output = [x_out y_out];

end
    