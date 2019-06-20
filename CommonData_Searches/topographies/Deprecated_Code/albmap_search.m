function [y1] = albmap_search(inputvec)
% Takes polar stereographic loaction and finds the corresponding cell in 
% albmap, and provides the elevation.


y1 = grdsearch(inputvec,'ALBMAP.nc');

end
        