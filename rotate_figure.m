function rotate_figure(total_rotation,steps,face,x1_y2_z3_axis)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('x1_y2_z3_axis') == 0
    x1_y2_z3_axis = 0;
end

if exist('face') == 0
    face = 0;
end

if face == 1
    set(gca,'CameraPosition',[1000 0 0]);
elseif face == 2
    set(gca,'CameraPosition',[0 1000 0]);
elseif face == 3
    set(gca,'CameraPosition',[0 0 1000]);
elseif face == 4
    set(gca,'CameraPosition',[-1000 0 0]);
elseif face == 5
    set(gca,'CameraPosition',[0 -1000 0]);
elseif face == 6
    set(gca,'CameraPosition',[0 0 -1000]);
end

if x1_y2_z3_axis == 0
    rotation_axis = [1 0 0];
elseif x1_y2_z3_axis == 1
    rotation_axis = [1 0 0];
elseif x1_y2_z3_axis == 2
    rotation_axis = [0 1 0];
elseif x1_y2_z3_axis == 3
    rotation_axis = [0 0 1];
end

c = get(gca);
set(gca,'cameraviewanglemode','manual')




look_vec = c.CameraPosition - c.CameraTarget;

dt = total_rotation/steps;

n_look_vec = rotate_3d(look_vec,rotation_axis,dt,0);

set(gca,'CameraPosition',[c.CameraTarget + n_look_vec]);


end