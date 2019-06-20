function plot_mccords(datafile,pickfile)
% Plots data from a CReSIS provided L2 data product.

cice_import

loadstring = ['load ',datafile];
eval(loadstring);

if exist('lat') == 1
    Latitude = lat;
    Longitude = long;
    Data = migdata;
    Time = travel_time*10e-7;
end

[x y] = polarstereo_fwd(Latitude,Longitude);
    
if exist('x_coord') == 1
    x = x_coord;
    y = y_coord;
end
if length(x(1,:)) == 1;
    distances = pointdistance([x(1:(length(x)-1)) y(1:(length(y)-1))], [x(2:end) y(2:end)]);
else
    distances = pointdistance([x(1:(length(x)-1))' y(1:(length(y)-1))'], [x(2:end)' y(2:end)']);
end


x_axis = [0];
for i = 1:length(distances)
    x_axis(i+1) = x_axis(i)+distances(i);
end
x_axis = x_axis/1000;

if exist('Surface') == 1
    Time = Time-Surface(1);
    starty = find(min(abs(Time)) == abs(Time))-20;
    endy = find(min(abs(Time-max(Bottom))) == abs(Time-max(Bottom))) + 20;
end
y_axis = Time*cice/2;




imagesc(x_axis,y_axis,20*real(log10(Data)));
colormap('gray')
if exist('Surface') == 1
    ylim([y_axis(starty) y_axis(endy)]);
end
colorbar
xlabel('Distance Along Line (km)')
ylabel('Depth (m)')
colorbar_label = colorbar;
ylabel(colorbar_label, 'Amplitude (dB)')

%Plots the picks in blue, if pick file included
if exist('pickfile') == 1
    hold all
    loadstring = ['load ',pickfile];
    eval(loadstring);
    line_2_plot = [];
    for i = 1:length(picks.samp2(:,1))
        for j = 1:length(picks.samp2(1,:))
            if isnan(picks.samp2(i,j)) == 1
                line_2_plot(j) = NaN;
            else
                line_2_plot(j) = y_axis(picks.samp2(i,j));
            end
        end
        plot(x_axis,line_2_plot,'Color','blue')
    end
end

if exist('Surface') == 1
    underscores = find(datafile == '_');
    periods = find(datafile == '.');
    title_end = periods(1)-1;
    for i = 1:(length(underscores)-1)
        if exist('title_start') == 0
            if underscores(i+1) - underscores(i) == 3;
                title_start = underscores(i+1)+1;
            end
        end
        datafile(underscores(i+1)) = '-';
    end
    
    title(datafile(title_start:title_end))
end
hold off
end