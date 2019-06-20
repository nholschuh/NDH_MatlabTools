function [angle]= segment_angle(lin1,lin2)
% This function returns the angle between two line segments. 
% Inputs are provided in the form lin1 and lin2 (2x2  
% matricies containing the endpoints of the segments in the form 
% [x1 y1;x2 y2])


slope1 = (lin1(1,2) - lin1(2,2))/(lin1(1,1) - lin1(2,1));
slope2 = (lin2(1,2) - lin2(2,2))/(lin2(1,1) - lin2(2,1));

if slope1 == Inf || slope1 == -Inf
    angle = rad2deg( pi/2 - atan2( (lin2(2,2)-lin2(1,2)) , (lin2(2,1)-lin2(1,1)) ) );
elseif slope2 == Inf || slope2 == -Inf
    angle = rad2deg( pi/2 - atan2((lin1(2,2)-lin1(1,2)),(lin1(2,1)-lin1(1,1))));
else
    angle_tan = (slope1 - slope2) / (1+slope1*slope2);
    angle = rad2deg(abs(atan2(angle_tan,1)));
end

if isnan(angle) == 1
    angle = 0;
end


%% This can be uncommented if you would like to plot the line segments and their intersection
% after completing the calculations

% plot([lin1(1,1) lin1(2,1)],[lin1(1,2) lin1(2,2)],'Color','blue')
% hold all
% plot([lin2(1,1) lin2(2,1)],[lin2(1,2) lin2(2,2)],'Color','red')
% hold off

end
