function location_map(x1,x2,y1,y2,quadrant_val,m0_or_km1,ant0_or_gre1,size_scale,latlon_flag,newaxis_flag);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Plots an Antarctic or Greenland Basemap on a figure, with a box outlining
% either a target area or the current figure limits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x1 - Left X Limit (set as 0, along with x2, to use figure xlim/ylim) This
%       can also be an Nx2 vector to plot a line instead of a box.
% x2 - Right X Limit
% y1 - Bottom Y Limit
% y2 - Top Y Limit
% quadrant_val - The quadrant of the figure you wish to plot the basemap
% m0_or_km1 - Whether or not the original figure is in m or km
% ant0_or_gre1 - Antarctica [0] or Greenland 1
% size_scale - This is a fractional scaling factor for the size of the
%              basemap
% latlon_flag - include latitidue and longitude markers
% newaxis_flag - Allows you to suppress the creation of a new axis
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('m0_or_km1') == 0
    m0_or_km1 = 0;
end

if exist('ant0_or_gre1') == 0
    ant0_or_gre1 = 0;
end

if exist('latlon_flag') == 0
    latlon_flag = 0;
end

if m0_or_km1 == 0
    mscaler = 1;
else
    mscaler = 1000;
end

if exist('newaxis_flag') == 0
    newaxis_flag = 1;
end

% if max(size(x1)) > 2
%     plot_line = x1;
%     x1 = min(plot_line(:,1));
%     x2 = max(plot_line(:,1));
%     y1 = min(plot_line(:,2));
%     y2 = max(plot_line(:,2));
%     plot_line_flag = 1;
% else
%     plot_line_flag = 0;
% end

if x1 == 0 & x2 == 0;
    xs = get(gca,'XLim');
    ys = get(gca,'YLim');
    x1 = xs(1)*mscaler;
    x2 = xs(2)*mscaler;
    y1 = ys(1)*mscaler;
    y2 = ys(2)*mscaler;
else
    x1 = x1*mscaler;
    x2 = x2*mscaler;
    y1 = y1*mscaler;
    y2 = y2*mscaler;
end

if exist('quadrant_val') == 0
    quadrant_val = 2;
end
if exist('size_scale') == 0
    size_scale = 1;
end


%% Generate the contour information (only run once to generate the input file
if 0
    [x y s] = A_Velocity('s',0,'a',0,0,0,0);
    cc = contour(x,y,s,[50 200]);
    c50 = find(cc(1,:) == 50);
    c200 = find(cc(1,:) == 200);
    c50(end+1) = c50(end)+1;
    dc50 = diff(c50);
    c200(end+1) = c200(end)+1;
    dc200 = diff(c200);
    counter = 1;
    for i = 1:length(c50)-1
        if dc50(i) > 100
            line{counter} = cc(:,c50(i)+1:c50(i+1)-1);
            line_ind(counter) = 1;
            counter = counter+1;
        end
    end
    for i = 1:length(c200)-1
        if dc200(i) > 100
            line{counter} = cc(:,c200(i)+1:c200(i+1)-1);
            line_ind(counter) = 2;
            counter = counter+1;
        end
    end
    close all
end

%%
%%%%%%%%%%%%%%%%%%%%% This sets up the appropriate Axes positions
fs = get(gcf,'Position');
ratio = fs(3)/fs(4);
ca = get(gca,'Position');
sv = 0.3*size_scale;
mf1 = 0.075; % the margin fraction (horizontal)
mf2 = 0.05; % the margin fraction (vertical)

if newaxis_flag == 1
    %%%% Notes:
    %%% ca(1:2) + ca(3:4) -> the top right corner position of the axes
    if quadrant_val == 1
        axes('Position',[ca(1:2)+ca(3:4)-[(sv+mf1)/ratio sv+mf2] sv/ratio sv])
    elseif quadrant_val == 2
        axes('Position',[ca(1:2)+[0 ca(4)]+[mf1/ratio -1*(sv+mf2)] sv/ratio sv])
    elseif quadrant_val == 3
        axes('Position',[ca(1:2)+[mf1/ratio mf2] sv/ratio sv])
    elseif quadrant_val == 4
        axes('Position',[ca(1:2)+[ca(3) 0]+[(sv+mf1)/-ratio mf2] sv/ratio sv])
    end
end


%%%%%%%%%%%% These are the grayscale values for plotting
    cc1 = 0.93; % Slower Contour
    cc2 = 0.85; % Fastest Contour
    cc3 = 0.8; % Total Shelf
    
    if ant0_or_gre1 == 0
        contour_subsetter = 100;
    else
        contour_subsetter = 10;
    end

if ant0_or_gre1 == 0
    load Ant_VelocityContours.mat
    
    xlim([-2600000,2600000])
    ylim([-2600000,2600000])    
    
    
    groundingline(5,0,1,[cc3 cc3 cc3],0,1);
    hold all
    groundingline(1,0,1,[1 1 1],contour_subsetter,1);
    colors = [cc1 cc1 cc1; cc2 cc2 cc2];
%     for i = 1:length(line_ind)
%         fill(line{i}(1,:),line{i}(2,:),colors(line_ind(i),:),'EdgeColor',colors(line_ind(i),:))
%     end
    groundingline(1,0,1,[0 0 0],contour_subsetter,0);
    
    if latlon_flag == 1
        plot_latlon(0,[1000 4500],[10 45])
    end

else
    xlim([-750000,850000])
    ylim([-3500000,-600000])

    groundingline(7,0,1,[cc3 cc3 cc3],contour_subsetter,1);
    hold all
    groundingline(6,0,1,[1 1 1],contour_subsetter,1);    
    
    if latlon_flag == 1
        plot_latlon(1,[1000 1000],[10 10],[40 80],[-70 -15],-950000,1050000,-3500000,-600000)
    end
end
    
    
    
    
%%%%%%%%%%%%%%%%%%%% This plots the inset box

    cs = color_call('darkblue');
    %cs = color_call('red');
    
    if max(size(x1)) == 1
        plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],'Color',cs,'LineWidth',2)
    else
        plot(x1(:,1),x1(:,2),'Color',cs','LineWidth',2)
    end
    
    
    
    
axis equal
axis off
