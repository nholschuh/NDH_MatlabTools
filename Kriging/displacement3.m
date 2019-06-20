function [dist] = displacement3(position,anisotropy)

% creates a matrix with distances between all points. for use with
% anisotropy factor
%
% usage:    [dist] = displacement3(position,anisotropy)

% Rolf Sidler 6.6.2003


% calculating distances between the points with respect to the anisotropy
for i = 1:length(position)
    for j = 1:i
        dist(i,j) = sqrt((position(i,1)-position(j,1))^2+anisotropy^2*(position(i,2)-position(j,2))^2);
    end
end