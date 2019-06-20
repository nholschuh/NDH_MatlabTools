function plot_clock(input_time,quadrant,size_scale)
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% This plots a visual representation of a clock to show time passing in
% animations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% time - the clock-time to plot in [hour minute]. a single value will be
% treated as an iterative time, indicating what percentage of the clock
% face to step forward.
% quadrant - the quadrant in which to plot the clock
% size-scale - a factor to increase or decrease the size relative to the
%               default
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('quadrant') == 0
    quadrant = 1;
end
if quadrant == 0
    quadrant = 1;
end
if exist('size_scale') == 0
    size_scale = 1;
end

if isdatetime(input_time)
    month_day = [month(input_time) day(input_time)]; 
    input_time = [hour(input_time) minute(input_time)];
end

%%%%%%%%%%%%%%%% Here we get the relevant exis information needed to scale
%%%%%%%%%%%%%%%% the clock properly

axis equal

figure_size = get(gcf,'Position');
axes_dim = get(gca,'Position');
axes_dim = [axes_dim(3)*figure_size(3) axes_dim(4)*figure_size(4)];
xs = get(gca,'XLim');
ys = get(gca,'YLim');

dxdp = diff(xs)/axes_dim(1);
dydp = diff(ys)/axes_dim(2);

%%%%%%%%%%%%%%%%% Here are the hardcoded parameters that define the
%%%%%%%%%%%%%%%%% distance from the figure edge to the clock, the hand
%%%%%%%%%%%%%%%%% size, the tick size, etc.
clockrad_px = 30;

clockrad_px = clockrad_px*size_scale;
indent_px = 0.1*axes_dim(1);

AM_margin_px = clockrad_px/10;

minute_hand_length_px = clockrad_px*2/3;
hour_hand_length_px = clockrad_px/2;
tick_length_px = clockrad_px/8;


%%%%%%%%%%%%%%%%% Clock dimensions, defined above in pixels, are converted
%%%%%%%%%%%%%%%%% to the units of the figure for proper plotting
clockrad_u = clockrad_px*dxdp; 
minute_hand_u = minute_hand_length_px*dxdp;
hour_hand_u = hour_hand_length_px*dxdp;
AM_margin_u = AM_margin_px*dxdp;


%%%%%%%%%%%%%%%%% Here the center of the clock coordinates are calculated
%%%%%%%%%%%%%%%%% based on the figure dimensions and the assigned values
%%%%%%%%%%%%%%%%% above.
if quadrant == 1
    clock_center = [xs(2)-indent_px*dxdp-clockrad_u ys(2)-indent_px*dydp-clockrad_u];
elseif quadrant == 2
    clock_center = [xs(1)+indent_px*dxdp+lockrad_u ys(2)-indent_px*dydp-clockrad_u];    
elseif quadrant == 3
    clock_center = [xs(1)+indent_px*dxdp+clockrad_u ys(1)+indent_px*dydp+clockrad_u];
elseif quadrant == 4
    clock_center = [xs(2)-indent_px*dxdp-clockrad_u ys(1)+indent_px*dydp+clockrad_u];    
end


%%%%%%%%%%%%%%%%%% Here the clock edge is defined, and the clock as well as
%%%%%%%%%%%%%%%%%% background boxes for the date and AM/PM are produced
angles = [0:0.1:2*pi 0];

facex = cos(angles)*clockrad_u+clock_center(1);
facey = sin(angles)*clockrad_u+clock_center(2);

hold all
if length(input_time) == 2
   y_t = clock_center(2)+sin(pi/3.8)*clockrad_u;
   y_b= clock_center(2)+sin(pi/2)*clockrad_u+10*dydp;
   x_l = clock_center(1);
   x_r = clock_center(1)+2*clockrad_u;
   fill([x_l x_r x_r x_l],[y_t y_t y_b y_b],'white','LineStyle','none')
end
if exist('month_day') == 1
   y_t = clock_center(2)+sin(-pi/4.5)*clockrad_u;
   y_b= clock_center(2)+sin(-pi/2)*clockrad_u-7*dydp;
   x_l = clock_center(1);
   x_r = clock_center(1)+2*clockrad_u;
   fill([x_l x_r x_r x_l],[y_t y_t y_b y_b],'white','LineStyle','none')    
end

fill(facex,facey,'white')
plot(facex,facey,'LineWidth',2,'color','black')


%%%%%%%%%%%%%% Here the tick marks on the clock are plotted
tick_length_u = tick_length_px*dxdp;

for i = 1:12
    tickx = [clock_center(1)+cos(2*pi*i/12)*(clockrad_u-tick_length_u) clock_center(1)+cos(2*pi*i/12)*(clockrad_u)];
    ticky = [clock_center(2)+sin(2*pi*i/12)*(clockrad_u-tick_length_u) clock_center(2)+sin(2*pi*i/12)*(clockrad_u)];
    plot(tickx,ticky,'LineWidth',0.2,'Color','black')
end 


%%%%%%%%%%%%%%% Here the hands on the clock are plotted
if length(input_time) == 1
   minute_vecx = [clock_center(1) cos(pi/2 - b2*pi*input_time/100)*minute_hand_u+clock_center(1)];
   minute_vecy = [clock_center(2) sin(pi/2 - 2*pi*input_time/100)*minute_hand_u+clock_center(2)];
   hour_vecx = [clock_center(1) clock_center(1)];
   hour_vecy = [clock_center(2) clock_center(2)];
else
   input_time(1) = input_time(1)+input_time(2)/60;
   minute_vecx = [clock_center(1) cos(pi/2 - 2*pi*input_time(2)/60)*minute_hand_u+clock_center(1)];
   minute_vecy = [clock_center(2) sin(pi/2 - 2*pi*input_time(2)/60)*minute_hand_u+clock_center(2)];
   hour_vecx = [clock_center(1) cos(pi/2 - 2*pi*input_time(1)/12)*hour_hand_u+clock_center(1)];
   hour_vecy = [clock_center(2) sin(pi/2 - 2*pi*input_time(1)/12)*hour_hand_u+clock_center(2)];
   AM_x = [clock_center(1)+cos(pi/4)*clockrad_u+AM_margin_u];
   AM_y = [clock_center(2)+sin(pi/4)*clockrad_u+AM_margin_u];
end

plot(minute_vecx,minute_vecy,'LineWidth',1.5,'Color','black')
plot(hour_vecx,hour_vecy,'LineWidth',2,'Color','black')
plot(clock_center(1),clock_center(2),'o','Color','black','MarkerSize',3,'MarkerFaceColor','black')


%%%%%%%%%%%%%%%% Here, text addenda are provided in the corner boxes
if length(input_time) == 2
    if input_time(1) > 24
        input_time(1) = input_time(1)-24;
    end
     
    if input_time(1) < 12
        time_str = 'A.M.';
    elseif input_time(1) >= 12
        time_str = 'P.M.';
    end
    text(AM_x,AM_y,time_str,'HorizontalAlignment','left','VerticalAlignment','bottom');
end

if exist('month_day') == 1
    md_str = [num2str(month_day(1)),'/',num2str(month_day(2))];
    MD_x = [clock_center(1)+cos(-pi/4)*clockrad_u+AM_margin_u];
    MD_y = [clock_center(2)+sin(-pi/4)*clockrad_u+AM_margin_u];
    text(MD_x,MD_y,md_str,'HorizontalAlignment','left','VerticalAlignment','top');
end

%%%%%%%%%%%%%%% The figure is then rescaled to the original axes limits

xlim(xs)
ylim(ys)

end









 