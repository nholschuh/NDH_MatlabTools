function quiver_2d(x,y,u,v,x_axis,scale,color_input)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
% This takes velocity values taken for individual traces of a 2D radar
% profile, computes the component in-to and out-of the page, and plots
% those values as arrows along the top of the current plot.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% x - x_coordinate for the traces
% y - y_coordinate for the traces
% u - x velocity at the trace
% v - y velocity at the trace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if exist('scale') == 0
    scale = 1/20;
else
    scale = scale/20;
end
if exist('color_input') == 0
    color_input = 'blue';
end


%%%%%%%%%% Make sure all the variables are in the proper orientation
sizex = size(x);
if sizex(2) > sizex(1)
    x = x';
    y = y';
end

sizeu = size(u);
if sizeu(2) > sizeu(1)
    u = u';
    v = v';   
end

size_xaxis = size(x_axis);
if size_xaxis(2) > size_xaxis(1)
    x_axis = x_axis';
end


%%%%%%%%%% Compute the relative bearing of the line and velocity
bearing = segment_bearing([x(1:end-2) y(1:end-2)],[x(3:end) y(3:end)]);
bearing = [bearing(1); bearing; bearing(end)];
v_bearing = segment_bearing(zeros(length(u),2),[u v]);


for i = 1:length(x);
    new_uv(i,:) = points_rotate([u(i) v(i)],90-bearing(i)); 
end


%%%%%%%%%% This rescales the vectors given the current scaling of the plot.
fig_size = get(gcf,'Position');
axis_size = get(gca,'Position');
axis_width = axis_size(3)*fig_size(3);
axis_height = axis_size(4)*fig_size(4);
yrange = get(gca,'ylim');
xrange = get(gca,'xlim');
py = yrange/axis_height;
px = xrange/axis_width;
aspect_ratio = py/px;

arrow_size = order(max(sqrt(new_uv(:,1).^2+new_uv(:,2))));

%%%% set up the plotting axis and add in the reference arrow
x_axis(end+1) = x_axis(1)+(xrange(2)-xrange(1))*0.1;
y_axis = ones(size(x_axis))*((yrange(2)-yrange(1))*0.1+yrange(1));
y_axis(end) = ((yrange(2)-yrange(1))*0.05+yrange(1));
new_uv(end+1,:) = [10^arrow_size 0];


new_uv(:,2) = new_uv(:,2)*aspect_ratio;

plot(x_axis(1:end-1),y_axis(1:end-1),'Color',[0.8 0.8 0.8],'LineWidth',1)
quiver(x_axis,y_axis,new_uv(:,1),new_uv(:,2),scale, ...
    'Color',color_input,'LineWidth',2);
text(x_axis(1)+(xrange(2)-xrange(1))*0.05,((yrange(2)-yrange(1))*0.05+yrange(1)),[num2str(10^arrow_size),' m/a'],'Color','white');


end
