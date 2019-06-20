function [grid] = within_grid_rectangle(xaxis,yaxis,boundaries)
% Determines whether or not the data within a given set of boundaries
% defined by their vertices. Skipper value is an efficiency algorithm,
% higher values makes the code run faster, but runs the risk of missing
% fine details. Angle_storage is used for debugging.

yaxis_vals = zeros(length(yaxis),length(boundaries(:,1))-1);
grid = zeros(size(meshgrid(xaxis,yaxis)));

for i = 1:length(boundaries(:,1))-1
    yaxis_vals(:,i) = interp1(boundaries(i:i+1,2),boundaries(i:i+1,1),yaxis);
end

for i = 1:length(yaxis)
    inds = find(xaxis > min(yaxis_vals(i,:)) & xaxis < max(yaxis_vals(i,:)));
    grid(i,inds) = 1;
end


end