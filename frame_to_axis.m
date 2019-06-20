function frame_to_axis()
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Eliminates the boundaries of the figure window, cropping just to the axis
% edges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

fp = get(gcf,'Position');

%%%%%%%%%%% Identify all the axes on the figure
cs = get(gcf,'Children');
for i = 1:length(cs)
    if length(cs(i).Type) == 4
        if cs(i).Type == 'axes'
            ps(i,:) = get(cs(i),'Position');
        end
    end
end

%%%%%%%%%%% Find the maximum edges of all axes, and define the figure to
%%%%%%%%%%% the minimum rectangular size that encompasses all axes
for i = 1:length(ps(:,1))
    axis_pixels(i,1:2) = [fp(1)+ps(i,1)*fp(3) fp(2)+ps(i,2)*fp(4)];
    axis_widths(i,:) = [fp(3)*ps(i,3) fp(4)*ps(i,4)];
    axis_pixels(i,3:4) = axis_pixels(i,1:2) + axis_widths(i,:);
end
    
new_f_pos = [min(axis_pixels(:,1)) min(axis_pixels(:,2)) max(axis_pixels(:,3)) max(axis_pixels(:,4))];
new_f_widths = [new_f_pos(3)-new_f_pos(1) new_f_pos(4)-new_f_pos(2)];


%%%%%%%%%%% Find the new relative positions for all axes
for i = 1:length(ps(:,1))
    axes_position(i,1) = (axis_pixels(i,1)-new_f_pos(1))/new_f_widths(1);
    axes_position(i,2) = (axis_pixels(i,2)-new_f_pos(2))/new_f_widths(2);
    axes_position(i,3) = 1-((new_f_pos(3)-axis_pixels(i,3)) + (axis_pixels(i,1)-new_f_pos(1)))/new_f_widths(1);
    axes_position(i,4) = 1-((new_f_pos(4)-axis_pixels(i,4)) + (axis_pixels(i,2)-new_f_pos(2)))/new_f_widths(2);
end

%%%%%%%%%%% Now reset the axes and the figure size
set(gcf,'Position',[new_f_pos(1:2) new_f_widths]);
for i = 1:length(ps(:,1));
    set(cs(i),'Position',axes_position(i,:));
end



