function figure_label(text_input,quadrant,box_width_px);
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% This plots a visual representation of a clock to show time passing in
% animations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% text - The text that will be plotted in the box
% quadrant - the quadrant in which to plot the clock
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('quadrant') == 0
    quadrant = 1;
end
if quadrant == 0
    quadrant = 1;
end

%%%%%%%%%%%%%%%% Here we get the relevant exis information needed to scale
%%%%%%%%%%%%%%%% the box properly
figure_size = get(gcf,'Position');
axes_dim = get(gca,'Position');
axes_dim = [axes_dim(3)*figure_size(3) axes_dim(4)*figure_size(4)];
xs = get(gca,'XLim');
ys = get(gca,'YLim');

dxdp = diff(xs)/axes_dim(1);
dydp = diff(ys)/axes_dim(2);

%%%%%%%%%%%%%%%%% Here are the hardcoded parameters that define the
%%%%%%%%%%%%%%%%% distance from the figure edge to the box, the box height,
%%%%%%%%%%%%%%%%% and the box width.
box_margin_px = 30;
box_height_px = 30;
if exist('box_width_px') == 0
    box_width_px = 30;
end

text_margin_px_x = box_width_px/2;
text_margin_px_y = box_height_px/2;
margin_ux = box_margin_px*dxdp; 
margin_uy = box_margin_px*dydp; 

box_height_u = box_height_px*dydp;
box_width_u = box_width_px*dxdp;


if quadrant == 1
    box_bl = [xs(2)-box_margin_px*dxdp-box_width_u ys(2)-box_margin_px*dydp-box_height_u];
elseif quadrant == 2
    box_bl = [xs(1)+box_margin_px*dxdp ys(2)-box_margin_px*dydp-box_height_u];    
elseif quadrant == 3
    box_bl = [xs(1)+box_margin_px*dxdp ys(1)+box_margin_px*dydp];
elseif quadrant == 4
    box_bl = [xs(2)-box_margin_px*dxdp-box_width_u ys(1)+box_margin_px*dydp];    
end

box = [box_bl];
box(2,:) = box(1,:);
box(2,1) = box(2,1)+box_width_u;
box(3,:) = box(2,:);
box(3,2) = box(3,2)+box_height_u;
box(4,:) = box(3,:);
box(4,1) = box(3,1)-box_width_u;
box(5,:) = box_bl;

text_pos = box_bl;
text_pos(1) = text_pos(1)+text_margin_px_x*dxdp;
text_pos(2) = text_pos(2)+text_margin_px_y*dydp;

hold all
fill(box(:,1),box(:,2),'White');
plot(box(:,1),box(:,2),'Color','black','LineWidth',1.5);

text(text_pos(1),text_pos(2),text_input,'HorizontalAlignment','center','VerticalAlignment','middle')

end





