function rotcoord = rotation(coord,alpha)

% rotates all coordinates round the coordinate origin for the angle
% 'alpha'. a full circle is 2*pi. the rotation is clockwise.
%
% usage:    (rotcoord) = rotation(coord,alpha)

% 19.6.2003 Rolf Sidler

rotcoord(:,1) = cos(alpha).*coord(:,1)+sin(alpha).*coord(:,2);
rotcoord(:,2) = -sin(alpha).*coord(:,1)+cos(alpha).*coord(:,2);
rotcoord(:,3) = coord(:,3);