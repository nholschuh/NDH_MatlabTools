function [y1] = bedmap2_search(inputvec,bed0_or_surf1_or_correction2)
% Takes polar stereographic loaction and finds the corresponding cell in 
% albmap, and provides the elevation.
if exist('bed0_or_surf1_or_correction2') == 0
    bed0_or_surf1_or_correction2 = 0;
end

if bed0_or_surf1_or_correction2 == 0
    y1 = grdsearch(inputvec,'Bedmap2_bed.grd');
elseif bed0_or_surf1_or_correction2 == 1
    y1 = grdsearch(inputvec,'Bedmap2_surface.grd');
elseif bed0_or_surf1_or_correction2 == 2
    % gives the height conversion values (as floating point) used to
    % convert from WGS84 datum heights to g104c geoidal heights (to 
    % convert back to WGS84, subtract this grid)
    y1 = grdsearch(inputvec,'g104c_geoid_to_WGS84.nc');
end

end
