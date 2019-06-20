function [x_out y_out]=polarstereo_reproject(x,y,repro_dir);
% This function is designed to take data projected with a standard
% longitude  of -45 and reproject it into a stereographic coordinate
% system with a standard longitude of -39 (or vice versa)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if exist('repro_dir') == 0
    repro_dir = 1;
end


if repro_dir == 1
    [lat lon] = polarstereo_inv(x,y,2);
    [x_out y_out] = polarstereo_fwd(lat,lon,1);
elseif repro_dir == 2
    [lat lon] = polarstereo_inv(x,y,1);
    [x_out y_out] = polarstereo_fwd(lat,lon,2);
end

end