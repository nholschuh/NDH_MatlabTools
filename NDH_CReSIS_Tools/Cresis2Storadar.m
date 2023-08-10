function Cresis2Storadar(filename,outputfile,startdepth,lp_flag)
% (C) Nick Holschuh - Penn State University - 2014 (Nick.Holschuh@gmail.com)
% Loads in one of the Cresis data files for use with St. Olaf's radar
% picker. Do not include the .mat in outputfile name.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% filename - The file name for the source data. If you instead provide a
% cell, include data in the structure described below.
% outputfile - The prefix used for the output file (w/o .mat)
% startdepth - The index for the starting time 
% lp_flag - 0 if the data is already in power, 1 if it must be converted
%           from amplitude to power
%
%%%%%%%
% ----- The variables that are required within the file are:
% Data
% Time
% Elevation
% Latitude
% Longitude
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%



if exist('startdepth') == 0
    startdepth = 1;
end

if startdepth == 0
    startdepth = 1;
end

if iscell(filename) == 0
    loadstring = ['load ',filename];
    eval(loadstring)
    
    %%% This extracts the date from the file name
    name_parts = strsplit(filename,'_');
    for i = 1:length(name_parts)
        if length(name_parts{i}) == 8
            try
                dec_day_mult = datenum(eval(name_parts{i}(1:4)),eval(name_parts{i}(5:6)),eval(name_parts{i}(7:8)));
            catch
                dec_day_mult = 2000;
            end
            break
        else
            dec_day_mult = 2000;
        end
    end
else
    Data = filename{1};
    Time = filename{2};
    Elevation = filename{3};
    Latitude = filename{4};
    Longitude = filename{5};
    
    dec_day_mult = 2000;
end



if exist('lp_flag') == 0
    lp_flag = 0;
end



ch_proc = 99;
chan = 2;
chdat = 10;
datavar = 'migdata';
decday = ones(length(Data(1,:)),1)*dec_day_mult;

dist = 1:(length(Data(1,:))-startdepth+1);

if exist('Latitude') == 1
    [x_coord y_coord] = polarstereo_fwd(Latitude,Longitude);
    dist = distance_vector(x_coord,y_coord);
end

dt = Time(2) - Time(1);
if exist('Elevation') == 1
    elev = Elevation;
else
    elev = zeros(length(dist));
end

elev_tide = zeros(1,length(elev));
lat = Latitude;
long = Longitude;
if lp_flag == 0
    migdata = Data(startdepth:length(Data(:,1)),:);
else
    migdata = lp(Data(startdepth:length(Data(:,1)),:));
end
pressure = 0;
procmenu = 0;
snum = length(Data(:,1))-startdepth+1;
tnum = length(Data(1,:));
tr_dx = 1;
trace_int = 1;
trace_num = 1:tnum;
travel_time = Time;
trig = 0;
trig_level = ones(1,tnum);
uice = 169;
predist = dist;
sddev_dist = std(dist);
avg_dist = mean(dist);


savestring = ['save ',outputfile,'_mig.mat avg_dist ch_proc chan chdat datavar decday dist dt elev elev_tide lat long migdata predist pressure procmenu sddev_dist snum tnum tr_dx trace_int trace_num travel_time trig trig_level uice x_coord y_coord'];
eval(savestring)