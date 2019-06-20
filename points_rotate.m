function new_points = points_rotate(points,angle)
% Rotates points clockwise by the angle provided
R = [cos(deg2rad(angle)) -sin(deg2rad(angle)); ...
     sin(deg2rad(angle)) cos(deg2rad(angle))];

 
%%%%%%% This code can take either a vertical vector or two matrices,
%%%%%%% containing the x and y components of the vector. The first case is
%%%%%%% for 2D, the second is for 3D
if ndims(points) == 2
    new_points = points*R;
elseif ndims(points) == 3
    dimsize = size(points);
    loop_ind = find(min(dimsize(1:2)) == dimsize(1:2));
    loops = dimsize(loop_ind);
    new_points = zeros(size(points));
    
    if loop_ind == 1;
        for i = 1:loops
            new_points(i,:,:) = squeeze(points(i,:,:))*R;
        end
    else
        for i = 1:loops
            new_points(:,i,:) = squeeze(points(:,i,:))*R;
        end        
    end
 
end

