function depth_axis = time2depth_axis(time_axis)
%% Converts a given time axis to an ice depth axis.

cice_import;

depth_axis = time_axis/2*cice;
end