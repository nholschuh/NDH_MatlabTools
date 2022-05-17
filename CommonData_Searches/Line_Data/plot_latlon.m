function plot_latlon(ant0_or_gre1,primary_lat_lon,secondary_lat_lon,latrange,lonrange,x1,x2,y1,y2,wmeta_flag)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function plots regular latitude and longitude lines on a given
% stereographic map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ant0_or_gre1 - either [0] for Antarctica or 1 for Greenland
% primary_lat_lon - nx2 The lat/lon spacing for the primary plot (black)
% secondary_lat_lon - nx2 The lat/lon spacing for the secondary plot (grey)
% latrange - 
% lonrange - 
% x1 - This input can take on two types of values:
%         1) A number (either m or km, depending on a later flag) that
%            defines the left boundary of the domain of interest.
%         2) Nothing, and the current bounds of the figure are used for x1,
%            x2, y1, and y2
% x2 - The right boundary of the domain (ignored if string for x1)
% y1 - The bottom boundary of the domain (ignored if string for x1)
% y2 - The top boundary of the domain (ignored if string for x1)
% wmeta_flag - choose whether or not to plot them with the ability to
% select the line to get the latitude/longitude value.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out1 - 
% out2 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%%% Assume Antarctica if nothing is provided
if exist('ant0_or_gre1') == 0
    ant0_or_gre1 = 0;
end
if exist('latrange') == 0
    latrange = [-90 90];
    lonrange = [-360 360];
end
if exist('wmeta_flag') == 0
    wmeta_flag = 1;
end

if exist('x1') == 0
    x1 = -3e6;
    x2 = 3e6;
    y1 = -3e6;
    y2 = 3e6;
end

if x1 == 0 & x2 == 0
    xs = get(gca,'XLim');
    ys = get(gca,'YLim');
    x1 = xs(1);
    x2 = xs(2);
    y1 = ys(1);
    y2 = ys(2);
end

within_box = box_from_corners(x1,x2,y1,y2);
xdiff = x2-x2;
ydiff = y2-y1;

if xdiff < 50000 | ydiff < 50000
    data_type = 1;
else
    data_type = 2;
end


if ant0_or_gre1 == 0
    if data_type == 1
        load LatLon_xy_highres_Antarctica.mat
    else
        load LatLon_xy_Antarctica.mat
    end
    
    if exist('primary_lat_lon') == 0
    primary_lat_lon = [30 30];
    secondary_lat_lon = [10 5];
    end
else
    if data_type == 1
        load LatLon_xy_highres_Greenland.mat
    else
        load LatLon_xy_Greenland.mat
    end
    
    if exist('primary_lat_lon') == 0
    primary_lat_lon = [30 10];
    secondary_lat_lon = [10 5];
    end
end

hold all
secondary_color = [0.9 0.9 0.9];

%%%%%%%%%%%%%%%%%%% Here we do the Latitude Arcs
for i = 1:length(lat_linesx)
    lattype(i) = 0;
    if lat_opts(i) >= latrange(1) & lat_opts(i) <= latrange(2)
        if mod(lat_opts(i),secondary_lat_lon(1)) == 0
            lattype(i) = 1;
        end
        if mod(lat_opts(i),primary_lat_lon(1)) == 0 & primary_lat_lon(1) < 90;
            lattype(i) = 2;
        end
    end
    
    inds = find(within(lat_linesx{i},lat_linesy{i},within_box(:,1),within_box(:,2)));
    
    if wmeta_flag == 0
        if lattype(i) == 2
            plot(lat_linesx{i}(inds),lat_linesy{i}(inds),'Color','black')
        elseif lattype(i) == 1
            plot(lat_linesx{i}(inds),lat_linesy{i}(inds),'Color',secondary_color)
        end
    else
        if lattype(i) == 2
            plot_wmeta(lat_linesx{i}(inds),lat_linesy{i}(inds),lat_opts(i),'Color','black');
        elseif lattype(i) == 1
            plot_wmeta(lat_linesx{i}(inds),lat_linesy{i}(inds),lat_opts(i),'Color',secondary_color);
        end        
    end
end


%%%%%%%%%%%%%%%%%%%% Here we do the longitude spokes
for i = 1:length(lon_linesx)
    lontype(i) = 0;

    if lon_opts(i) >= lonrange(1) & lon_opts(i) <= lonrange(2)
        if mod(lon_opts(i),secondary_lat_lon(2)) == 0
            lontype(i) = 1;
        end
        if mod(lon_opts(i),primary_lat_lon(2)) == 0 & primary_lat_lon(2) < 360
            lontype(i) = 2;
        end
    end
    
    inds = find(within(lon_linesx{i},lon_linesy{i},within_box(:,1),within_box(:,2)));
    if wmeta_flag == 0
        if lontype(i) == 2
            plot(lon_linesx{i}(inds),lon_linesy{i}(inds),'Color','black')
        elseif lontype(i) == 1
            plot(lon_linesx{i}(inds),lon_linesy{i}(inds),'Color',secondary_color)
        end
    else
        if lontype(i) == 2
            plot_wmeta(lon_linesx{i}(inds),lon_linesy{i}(inds),lon_opts(i),'Color','black');
        elseif lontype(i) == 1
            plot_wmeta(lon_linesx{i}(inds),lon_linesy{i}(inds),lon_opts(i),'Color',secondary_color);
        end
    end
end

end

