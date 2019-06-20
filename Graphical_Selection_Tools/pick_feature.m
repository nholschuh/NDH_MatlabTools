function [pick_vals point_inds] = pick_feature(x_coords,y_coords,time,surf,data);

dist = distance_vector(x_coords,y_coords);
cice_import

imagesc(dist,time*cice/2,data);
colormap(gray)

points = graphical_selection(1);

for i = 1:length(points(:,1))
    point_inds(i) = find_nearest(dist,points(i,1));
end

x1 = find_nearest(dist, min(points(:,1)));
x2 = find_nearest(dist, max(points(:,1)));

pick_vals(:,1) = x_coords(x1:x2);
pick_vals(:,2) = y_coords(x1:x2);
pick_vals(:,3) = surf(x1:x2)'-interp1(points(:,1),points(:,2),dist(x1:x2));
pick_vals(:,4) = x1:x2;

end