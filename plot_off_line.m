function d_p = plot_off_line(x,y,r0_l1,dist_off)

if r0_l1 == 0
    angle = 90;
else
    angle = -90;
end

d_p = [x(2:end)-x(1:end-1) y(2:end)-y(1:end-1)];
lengths = sqrt(d_p(:,1).^2+d_p(:,2).^2);
d_p = d_p./[lengths lengths]*dist_off;

d_p(end+1,:) = [0 0];

d_p = points_rotate(d_p,angle);
dists = distance_vector(x,y,1);
min_t = mean(dists(find(dists > 0)));
fix_inds = find(dists > min_t*1.5);
fix_inds2 = fix_inds-1;


for i = 1:length(fix_inds)
    d_p(fix_inds(i),:) = d_p(fix_inds(i)+1,:);
end
for i = 1:length(fix_inds2)
    d_p(fix_inds2(i),:) = d_p(fix_inds2(i)-1,:);
end

d_p = d_p + [x y];

end




