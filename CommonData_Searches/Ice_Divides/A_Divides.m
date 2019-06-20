function  output = A_Divides(ds,divides,plotter);

data = dlmread('Antarctica_Divides_Grounded.txt','\t',7,0);
data = reshape(data,,)
if exist('ds') == 0
    ds = 10;
end
if exist('plotter') == 0
    plotter = 1;
end

data = data(1:ds:end,:);


divide_options = remove_duplicates(data(:,3));
[x y] = polarstereo_fwd(data(:,1),data(:,2));

if exist('divides') == 0
    divides = divide_options;
end

if length(divides) == 1 && divides == 0
    colors = jet(length(divide_options));
    a = figure(10);
    for i = 1:length(divide_options)
        temp_ind = find(data(:,3) == divide_options(i));
        plot(x(temp_ind(1):50:temp_ind(end)),y(temp_ind(1):50:temp_ind(end)),'o','Color',colors(i,:),'MarkerFaceColor',colors(i,:),'MarkerSize',1);
        hold all
    end
    colormap(jet(length(divide_options)))
    caxis([1 length(divide_options)])
    colorbar
    axis square
    pause(1)
    divide_select = inputdlg('Divides? (separate with spaces)');
    keyboard
    divide_select = strsplit(divide_select{1},' ');
    divides = [];
    for i = 1:length(divide_select)
        divides = [divides eval(divide_select{i})];
    end
    close(a)
end


x_out = [];
y_out = [];

for i = 1:length(divides)
    temp_ind = find(data(:,3) == divides(i));
    y_out = [y_out; y(temp_ind)];
    x_out = [x_out; x(temp_ind)];
    if plotter == 1
        plot(x(temp_ind),y(temp_ind),'o','Color',[0.6 0.6 0.6],'MarkerSize',1);
        hold all
    end
end
if plotter == 1
    groundingline(1);
    axis square
end
output = [x_out y_out];

end
    