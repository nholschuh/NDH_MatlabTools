function [surf_dist3 bed_dist3] = pr_correction(pitch,roll,surface,bed)
% Corrects Radar Data timing for the Pitch and Roll of the plane. Outputs
% results as vertical distance to surface, and vertical distance from ice
% surface to bed (ie, thickness).
cair_import;
cice_import;

% Pitch Correction - Pitch is the angle from horizontal, rotated
% around an axis parallel to the wings.

surf_dist = surface*cair/2;
surf_dist2 = surf_dist.*cos(pitch); % Vert-distance in the plane of the wings.

ice_time = bed-surface;
bed_pitch = pitch*cice/cair;
bed_dist = ice_time*cice/2;
bed_dist2 = bed_dist.*cos(bed_pitch);

% Yaw Correction - Yaw is the angle from horizontal, rotated around an axis
% parallel to the fuselage.

surf_dist3 = surf_dist.*cos(roll);

bed_roll = roll*cice/cair;
bed_dist3 = bed_dist2.*cos(bed_roll);








