function potential = hydropotential(Surface,Bed);
%Calculates the Hydraulic Potential Given data for the Ice Surface
%Elevation and Ice Bed Elevation. Results are in Pa

rhoi = 917;
rhow = 1000;
g=9.8;
h = Surface - Bed;

potential = rhoi*g*h+rhow*g*Bed;
end


%% Reworking to show the original derivation.
% ri g (s - z)  +  rw g z
% ri g s + (rw-ri) g z