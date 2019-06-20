function theta2 = snells_law(theta1,e1,e2,perm0_or_vel1)
% (C) Nick Holschuh - Penn State University - 2015 (Nick.Holschuh@gmail.com)
% This solves for the outgoing refracted angle given two dielectric
% permittivities or wave speeds.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% theta1 - The incoming angle (in radians) from medium 1
% e1 - The permittivity (or wave speed) of medium 1
% e2 - The permittivity (or wave speed) of medium 2
% perm0_or_vel1 - 0, e1/e2 are permittivities, 1, e1/e2 are velocities. The
%                 default is 0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if exist('perm0_or_vel1') == 0
    perm0_or_vel1 = 0;
end
%%%% Converts from Permittivities to velocities
if perm0_or_vel1 == 0
    cair_import
    e1 = cair/sqrt(e1);
    e2 = cair/sqrt(e2);
end
    
theta2 = asin(sin(theta1)*e2/e1);

end
