function outplane = slice_ndh(x,y,z,volume,plane_orientation,d_from_center,plotter);
% (C) Nick Holschuh - University of Washington - 2017 (Nick.Holschuh@gmail.com)
% This extracts an arbitrary slice as a function of angle through a 3D
% volume.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% x - the xaxis for the volume
% y - the yaxis for the volume
% z - the zaxis for the volume
% volume - the data volume
% plane_orientation: There are several options for entry in this object
%    1 - {'x'|'y'|'z' vec1 vec2}
%    2 - [x1 y1 z1]
%
%    option one creates a plane that always contains the axis provided
%    first, with either a relative angle providing the direction for the
%    plane or a vector to determine it
%    option 2 takes the normal to the plane
% d_from_center
% plotter - [1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('plotter') == 0
    plotter = 1;
end

total_dx = max(x)-min(x);
total_dy = max(y)-min(y);
total_dz = max(z)-min(z);
dx = x(2)-x(1);
dy = y(2)-y(1);
dz = z(2)-z(1);



centerpoint = [mean(x) mean(y) mean(z)];

%%%%%%%%%%%%%%%%%%% Here, we approximate the required size for the grid
if iscell(plane_orientation) == 1
    if plane_orientation{1} == 'x'
        max_dims = sqrt(total_dy.^2 + total_dz.^2);
        step = round_to(mean([dy,dz]),0.5);
    elseif plane_orientation{1} == 'y';  
        max_dims = sqrt(total_dx.^2 + total_dz.^2);
        step = round_to(mean([dx,dz]),0.5);
    elseif plane_orientation{1} == 'z';
        max_dims = sqrt(total_dx.^2 + total_dy.^2);
        step = round_to(mean([dx,dy]),0.1);
    end
else
    max_dims = sqrt(total_dx.^2 + total_dy.^2 + total_dz.^2);
    step = round_to(mean([dx,dy,dz]),0.5);
end

max_dims = round_to(max_dims*0.75,0.5);

%%%%%%%%%%%%%%%%%%% Here, we define the proper normal vector to produce the
%%%%%%%%%%%%%%%%%%% plane of interest
if iscell(plane_orientation) == 1
   if plane_orientation{1} == 'x';
       temp_orientation = points_rotate([plane_orientation{2} plane_orientation{3}],90);
       plane_orientation = [0 temp_orientation];
       [P,Q] = meshgrid(-round_to(total_dx/2,0.5):dz:round_to(total_dx/2,0.5),-max_dims:step:max_dims);
   elseif plane_orientation{1} == 'y';
       temp_orientation = points_rotate([plane_orientation{2} plane_orientation{3}],90);
       plane_orientation = [temp_orientation(1) 0 temp_orientation(2)];   
       [P,Q] = meshgrid(-round_to(total_dy/2,0.5):dz:round_to(total_dy/2,0.5),-max_dims:step:max_dims);
   elseif plane_orientation{1} == 'z';
       temp_orientation = points_rotate([plane_orientation{2} plane_orientation{3}],90);
       plane_orientation = [temp_orientation 0];   
       [P,Q] = meshgrid(-max_dims:step:max_dims,-round_to(total_dz/2,0.5):dz:round_to(total_dz/2,0.5));
   end
else
    [P,Q] = meshgrid(-max_dims:step:max_dims);
end
    
plane_orientation_mag = sqrt(sum(plane_orientation.^2));
plane_orientation = plane_orientation/plane_orientation_mag;

%%%%%%%%%%%%%%%%%%%% Here, we compute that plane subject to the centerpoint
%%%%%%%%%%%%%%%%%%%% and the lateral range required;
   w = null(plane_orientation); % Find two orthonormal vectors which are orthogonal to v
   X = centerpoint(1)+d_from_center*plane_orientation(1)+w(1,1)*P+w(1,2)*Q; % Compute the corresponding cartesian coordinates
   Y = centerpoint(2)+d_from_center*plane_orientation(2)+w(2,1)*P+w(2,2)*Q; %   using the two vectors in w
   Z = centerpoint(3)+d_from_center*plane_orientation(3)+w(3,1)*P+w(3,2)*Q;
   
   
   V = interp3(x,y,z,volume,X,Y,Z,'linear');
   if plotter == 1
       hh = slice(x,y,z,volume,X,Y,Z);
       set(hh,'EdgeColor','none');
   end
   outplane = {X,Y,Z,V};
   
end









