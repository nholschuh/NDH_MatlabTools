function [y1] = surface_search(inputvec)
% Takes polar stereographic loaction and finds the corresponding cell in 
% albmap, and provides the elevation.


y1 = grdsearch(inputvec,'Bedmap2_surface.grd');

end
        