function [slopedif]= segment_angle(lin1,lin2)
% This function returns the difference in slope between two line segments. 
% Inputs are provided in the form lin1 and lin2 (2x2  
% matricies containing the endpoints of the segments in the form 
% [x1 y1;x2 y2])


slope1 = (lin1(1,2) - lin1(2,2))/(lin1(1,1) - lin1(2,1));
slope2 = (lin2(1,2) - lin2(2,2))/(lin2(1,1) - lin2(2,1));

slopedif = abs(slope1-slope2);


%% This can be uncommented if you would like to plot the line segments and their intersection
% after completing the calculations
% 
% plot([lin1(1,1) lin1(2,1)],[lin1(1,2) lin1(2,2)],'Color','black')
% hold all
% plot([lin2(1,1) lin2(2,1)],[lin2(1,2) lin2(2,2)],'Color','black')
% hold off

end
