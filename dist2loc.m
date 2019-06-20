function locations = dist2loc(distances)
% Takes a set of distances (dx) and converts them to their position (x),
% assuming x(1) = 0;

locations = 0;

for i = 1:length(distances)
    locations(i+1) = sum(distances(1:i));
end
end