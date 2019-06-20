function i_reflectivity = internal_reflectivity(Data,surface,time,windowsize,type);
% This function calculates the average reflective power of the column between
% the top reflective surface and a given depth, uncorrected. 'type'
% variable indicates whether or not the data is in 0=power or 1=amplitude.
% Default value is 0. 'time' is a vector converting matrix index to time.

if exist('type') == 0
    type = 0;
end

if rem(surface(1),1) == 0
    surface_ind = surface;
    max_surface_ind = max(surface_ind);
else
    surface_ind = (surface-time(1))/(time(2)-time(1))+1;
    max_surface_ind = max(surface_ind);
end

startindex = max_surface_ind+30;
endindex = max_surface_ind+30+windowsize;


if type == 1
    Powervec = Data.*Data;    
elseif type == 0
    Powervec = Data;
end


results = sum(Data(startindex:endindex,:));

i_reflectivity = results;

end