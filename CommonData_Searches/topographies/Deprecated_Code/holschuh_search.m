function [y1] = holschuh_search(inputvec)
% Takes polar stereographic loaction and finds the corresponding cell in 
% albmap, and provides the elevation.


y1 = grdsearch(inputvec,'NDH_ALBMAP.grd');

end
        