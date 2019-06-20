function [x2 y2] = line_extend(x,y,front_extend,back_extend,distance_or_steps);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This function linearly extrapolates to extend lines by a fixed distance
% or by a number of additional steps, given constant spacing in the current
% line.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x - the x coordinates of the line
% y - the y coordinates of the line
% front_extend - either a distance, or a number of steps to extend at line
%               start
% back_extend - either a distance, or a number of steps to extend at line
%               end
% distance_or_steps - [0] for a fixed distance, 1 for steps out
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x - The new x coordinates
% y - The new y coordinates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Extends a provided line by the distances provided;

if exist('distance_or_steps') == 0
    distance_or_steps = 0;
end

debug = 0;
if debug == 1
    x = [1 2]';
    y = [1 4]';
    front_extend = 1;
    back_extend = 0.5;
    plot(x,y,'o-','Color','blue')
    hold all
end

dx = mean(distance_vector(x,y,1));

if distance_or_steps == 0
    front_steps = round(front_extend/dx);
    back_steps = round(back_extend/dx);
else
    front_steps = front_extend;
    back_steps = back_extend;
end

slope1 = slopeintercept([x(1) y(1)],[x(2) y(2)]);
s1_u = [sqrt(1/(slope1^2+1)) slope1*sqrt(1/(slope1^2+1))];

slope2 = slopeintercept([x(end) y(end)],[x(end-1) y(end-1)]);
s2_u = [sqrt(1/(slope2^2+1)) slope2*sqrt(1/(slope2^2+1))];

if length(x(1,:)) > length(x(:,1))
    x2 = [x(1)-s1_u(1)*(1:front_steps) x x(end)+s2_u(1)*(1:back_steps)*dx];
    y2 = [y(1)-s1_u(2)*(1:front_steps) y y(end)+s2_u(2)*(1:back_steps)*dx];
else
    x2 = [x(1)-s1_u(1)*[1:front_steps]'; x; x(end)+s2_u(1)*[1:back_steps]'*dx];
    y2 = [y(1)-s1_u(2)*[1:front_steps]'; y; y(end)+s2_u(2)*[1:back_steps]'*dx];
end


if debug == 1
    hold off
    plot(x2,y2,'o','Color','red','MarkerFaceColor','red')
    hold
    plot(x,y,'.','Color','blue')
end

end
