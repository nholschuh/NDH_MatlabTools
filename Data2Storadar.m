function Data2Storadar(Data,Time,Latitude,Longitude,outputfile,elev,datatype,x_coord,y_coord)
% (C) Nick Holschuh - University of Washington - 2016 (Nick.Holschuh@gmail.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are:
%
% ________ - 
% ________ - 
% ________ - 
% ________ - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are:
%
% ________ - 
% ________ - 
% ________ - 
% ________ - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Dependencies are:
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('datatype') == 0
    datatype = 0;
end
if exist('elev') == 0
    elev = [];
end

if datatype == 0
    datavar = 'migdata';
    suffix = '_mig';
elseif datatype == 1
    datavar = 'interp_data';
    suffix = '_interp';
end

% The variables this needs are:
% Data
% Time
% Elevation
% Latitude
% Longitude


startdepth=1;
lp_flag = 0;

ch_proc = 99;
chan = 2;
chdat = 10;
decday = ones(length(Data(1,:)),1)*datenum(date);
if exist('Latitude') == 1 & exist('x_coord') == 0
    [x_coord y_coord] = polarstereo_fwd(Latitude,Longitude);
end
dist = distance_vector(x_coord,y_coord,0);

dist = 1:(length(Data(1,:))-startdepth+1);
dt = Time(2) - Time(1);

if length(elev) == 0
    elev = zeros(length(dist));
end
elev_tide = zeros(1,length(elev));
lat = Latitude;
long = Longitude;
if lp_flag == 0
    eval_str = [datavar,' = Data(startdepth:length(Data(:,1)),:);'];
else
    eval_str = [datavar,' = lp(Data(startdepth:length(Data(:,1)),:));'];
end
eval(eval_str)
pressure = 0;
procmenu = 0;
snum = length(Data(:,1))-startdepth+1;
tnum = length(Data(1,:));
tr_dx = 1;
trace_int = 1;
trace_num = 1:tnum;
travel_time = Time;

trigval = find_nearest(Time,0);
trig = ones(1,tnum)*trigval;
trig_level = ones(1,tnum);
uice = 169;
predist = dist;
sddev_dist = std(dist);
avg_dist = mean(dist);



savestring = ['save ',outputfile,suffix,'.mat avg_dist ch_proc chan chdat datavar decday dist dt elev elev_tide lat long ',datavar,' predist pressure procmenu sddev_dist snum tnum tr_dx trace_int trace_num travel_time trig trig_level uice x_coord y_coord'];
eval(savestring)
end