function output = restructure_GLAH12(data,filt_flag);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% This takes the typical ATL06 data structure and extracts just x,y,z,time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% data - an ATL06 file read by the normal ATL06 reader
% filt - Apply the ATL06 Quality Filter (1)
% out_form - Either as 6 beams (1) or as 1 vector (0);
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

output = struct('x',[],'y',[],'h',[],'time',[]);

[x y] = polarstereo_fwd(data.Data_40HZ.Geolocation.d_lat,data.Data_40HZ.Geolocation.d_lon);
h = data.Data_40HZ.Elevation_Surfaces.d_elev;
ds = datenum(2000,1,1,0,0,data.Data_40HZ.DS_UTCTime_40);
[trash trash time] = doy(ds);

if filt_flag == 1
    keeps = find(data.Data_40HZ.Quality.elev_use_flg == 0);
else
    keeps = 1:length(data.Data_40HZ.Quality.elev_use_flg);
end

output.x = x(keeps);
output.y = y(keeps);
output.h = h(keeps);
output.time = time(keeps);













