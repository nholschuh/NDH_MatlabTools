function [xmesh ymesh outgrid] = remesh_ndh(x,y,gridval,x_upscale,y_upscale);


%%%% This interpolates in the y direction
for i = 1:length(x(1,:))
    ny(:,i) = line_fill(y(:,i),y_upscale,0);
    nx(:,i) = interp1(y(:,i),x(:,i),ny(:,i));
    ng(:,i) = interp1(y(:,i),gridval(:,i),ny(:,i));
end

%%%% This interpolates in the x direction
for i = 1:length(nx(:,1))
    nx1(i,:) = line_fill(nx(i,:),x_upscale,0);
    ny1(i,:) = interp1(nx(i,:),ny(i,:),nx1(i,:));
    ng1(i,:) = interp1(nx(i,:),ng(i,:),nx1(i,:));
end

outgrid = ng1;
xmesh = nx1;
ymesh = ny1;

end