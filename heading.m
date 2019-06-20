function result = heading(point1,point2);
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% Calculates the heading (relative to north) of a line segment, going from
% point1 to point2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% point1 - [x1 y1]
% point2 - [x2 y2]
%
%%%%%%%%%%%%%%%
% The outputs are:
%
% result - The heading, in degrees (East of North)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

slope = (point2(2)-point1(2))/(point2(1)-point1(1));

angle = atan(slope);
if(point1(1) > point2(1))
    if angle < 1
        result = 270 - rad2deg(angle);
    else
        result = 270 + rad2deg(angle);
    end
else
    if angle < 1
        result = 90 - rad2deg(angle);
    else
        result = 90 + rad2deg(angle);
    end
end

end

    