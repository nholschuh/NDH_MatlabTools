function distance_vec = location2distance(x,y)
% Converts a vector of locations to the relative distances from one point
% to the next. Automatically determines if lat/lon or already in polar
% stereo.

distance_vec = [0];

if max([abs(x); abs(y)]) < 181;
    [x y] = polarstereo_fwd(x,y);
end

for i = 1:(length(x)-1)
    distance_vec(i+1) = distance_vec(i) + pointdistance([x(i) y(i)],[x(i+1) y(i+1)]);
end
end
    