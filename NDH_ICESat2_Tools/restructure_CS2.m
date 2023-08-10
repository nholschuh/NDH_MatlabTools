function output = restructure_ATL06(data,filt_flag);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% This takes the typical ATL06 data structure and extracts just x,y,z,time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% data - an ATL06 file read by the normal ATL06 reader
% filt - Apply the ATL06 Quality Filter (1)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% output - rewritten data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('filt_flag') == 0
    filt_flag = 1;
end

start_time = data.GEO.Start_Time;
lat = matrix_to_vector(data.MEA.LAT_20Hz);
lon = matrix_to_vector(data.MEA.LON_20Hz);
H = matrix_to_vector(data.MEA.surf_height_r1_20Hz);
qual_flag =  matrix_to_vector(data.MEA.Qual_flag_20Hz.height_err_r1);;

%%%%%%%%%%% First we reconstruct the observation time
time = start_time+data.GEO.Elapsed_Time;
r_time = data.MEA.delta_time_20Hz;
ss = size(r_time);
time = matrix_to_vector(repmat(time',ss(1),1)+r_time);


dn = datenum(2000,0,0,0,0,time);
[trash trash time] = doy(dn);

[x y] = polarstereo_fwd(lat,lon);

if filt_flag == 1
    inds = find(qual_flag == 0 & (lat < -50 | lat > 50));
end

output.x = x(inds);
output.y = y(inds);
output.h = H(inds);
output.lat = lat(inds);
output.lon = lon(inds);
output.time = time(inds);


end








