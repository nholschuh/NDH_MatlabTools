function angle = segment_bearing(point1,point2,full_or_half_flag);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Designed to calculate the 360 or 180 degree bearing, with 0 = up the y
% axis (or north) and progressing clockwise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% point1 - either supply origin points for vectors with terminii at point2
%          or supply a vector where bearings are computed progressively
% point2 - the terminii for vectors starting at point 1, or [empty] for
%          progressive bearing
% full_or_half_flag - [0] for 0-360 bearing, or 1 for 1-180 symmetric
%                     bearing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% angle - the segment bearing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('point2') == 0
    point2 = [];
end
if exist('full_or_half_flag') == 0
    full_or_half_flag = 0;
end

if isempty(point2) == 1
    continuous_flag = 1;
    point2 = point1(2:end,:);
    point1 = point1(1:end-1,:);
else
    continuous_flag = 0;
end

slope = (point2(:,2)-point1(:,2))./(point2(:,1)-point1(:,1));
angle = 90-rad2deg(atan(slope));

add_ind = [point2(:,1) - point1(:,1) < 0];

if full_or_half_flag == 0
    angle = angle+add_ind*180;
end

if continuous_flag == 1
    angle = [angle; angle(end)];
end


end

