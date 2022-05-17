function [newx,newy] = distance_separator(x,y,dist_jump)

dists = distance_vector(x,y,1);

rep_inds = find(dists > dist_jump);

newx = x;
newy = y;
newx(rep_inds) = NaN;
newy(rep_inds) = NaN;



end