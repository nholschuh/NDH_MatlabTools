function [slope intercept] = slopeintercept(point1,point2)
% Outputs the Slope and Intercept values for the line between two points
x = point1;
z = point2;

if x(1) < z(1)
else
    y = x;
    x = z;
    z = y;
end

a =(z(2)-x(2))/(z(1)-x(1));

b = x(2) - a*x(1);
if a == Inf || a == -Inf 
    b = x(1);
end

slope = a;
intercept = b;
end