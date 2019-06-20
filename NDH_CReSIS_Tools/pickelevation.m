function [pick_elev surface_elev] = pickelevation(elevation,surface,pick,time)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% Calculates the surface elevation and elevation for a picked horizon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% elevation - Provide a vector with the flight elevations in meters (if
%       instead you provide a 0, it is assumed to be at the ice surface)
% surface - Provide a vector with either the pick index or twtt for the
%       target reflector. The code can intelligently identify which you've 
%       provided.
% pick - Provide a vector with either the pick index or twtt for the ice
%       surface. The code can intelligently identify which you've provided.
% time - vector that relates index to twtt
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cice_import
cair_import

% Converting all variables to times

if elevation == 0;
    elevation = zeros(length(pick),1);
end
if surface == 0;
    surface = zeros(length(pick),1);
end
if pick == 0;
    pick = surface;
end

% Ensuring all vectors are vertical
s1 = size(elevation);
s2 = size(surface);
s3 = size(pick);
s4 = size(time);

if find(s1 == max(s1)) == 2
    elevation = elevation';
end
if find(s2 == max(s2)) == 2
    surface = surface';
end
if find(s3 == max(s3)) == 2
    pick = pick';
end
if find(s4 == max(s4)) == 2
    time = time';
end

%%%%%%%%% This determines if the variables are:
% 0 - Indecies
% 1 - time

if min(surface) < 1
    type1 = 1;
else
    type1 = 0;
end

if min(pick) < 1
    type2 = 1;
else
    type2 = 0;
end

if abs(time(2) - time(1)) > .00001
    time = time*10e-6;
end

if type1 == 0
    surface = NaN2value(surface,1);
    %%% This computes a weighted average of the times on either side of a
    %%% pick index
    surface_time = time(ceil(surface)).*(1-mod(surface,1)) + time(floor(surface)).*(mod(surface,1));  
elseif type1 == 1
    surface_time = surface;
end

if type2 == 0
    pick = NaN2value(pick,1);
    pick_time = time(ceil(pick)).*(1-mod(pick,1)) + time(floor(pick)).*(mod(pick,1));  

elseif type2 == 1
    pick_time = pick;
end


nanfixindex1 = find(time(1)==pick_time);
nanfixindex2 = find(time(1)==surface_time);

pick_time(nanfixindex1) = pick_time(nanfixindex1)*NaN;
surface_time(nanfixindex2) = surface_time(nanfixindex2)*NaN;
    

% Setting all of the important vectors to vertical vectors

if length(pick_time(:,1)) < length(pick_time(1,:))
    pick_time = pick_time';
end

if length(surface_time(:,1)) < length(surface_time(1,:))
    surface_time = surface_time';
end

if length(elevation(:,1)) < length(elevation(1,:))
    elevation = elevation';
end
    


pick_elev = [];
surface_elev = elevation - surface_time*cair/2;

for i = 1:length(pick(1,:))

    pick_elev(:,1) = surface_elev - (pick_time(:,1) - surface_time)*cice/2;
    
end


end
    