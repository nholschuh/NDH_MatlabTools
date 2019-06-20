function distvec = distance_vector(x,y,total0_or_increment1)
% Calculates a vector of distance along a line given the x and y
% coordinates of that line.

if exist('total0_or_increment1') == 0
    total0_or_increment1 = 0;
end
if exist('y') == 0
    y = zeros(length(x),1);
end

distvec(1) = [0];
for i = 1:(length(x)-1)
    if total0_or_increment1 == 0
        distvec(i+1) = distvec(i) + pointdistance([x(i) y(i)],[x(i+1) y(i+1)]);
    else
        distvec(i) = pointdistance([x(i) y(i)],[x(i+1) y(i+1)]);
    end
end
end
    