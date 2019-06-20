function [chan,data,dist,dt,elev,...
        flags,lat,long,pressure,snum,tnum,trace_int,...
        trace_num,travel_time,trig,trig_level,x_coord,y_coord] = read_pulse_ekko(filename,sflag)

%this is a not done function to read pulse ekko data into matlab and
%convert to stro_radar format

%Knut Christianson 6 April 2017; 20 May 2017

%inputs: 

%need to set from the header file (this should be done automatically
%snum -- number of samples per trace
%tnum -- number of traces in file
%filename is name of file (should set everything to be reader from the file
%name so reads in number of traces and samples from header and gps files
%and no need to manually input theres

%outputs: 

%sto_radar raw matlab data format for stodeep

%% basic info for reading in data;


hdname = filename;
%basic variables
%number of traces

fd = fopen(hdname);

temp = fgetl(fd);
counter = 1;
while length(temp) ~= 1
    if str_contain(temp,'=') == 1
        stropts = strsplit(temp,'=');
        if str_contain(stropts{1},'NUMBER OF TRACES');
            tnum = eval(stropts{2});
        elseif str_contain(stropts{1},'NUMBER OF PTS/TRC');
            snum = eval(stropts{2});
        elseif str_contain(stropts{1},'TOTAL TIME WINDOW');
            window = eval(stropts{2});
        elseif str_contain(stropts{1},'TIMEZERO AT POINT');
            trig = eval(stropts{2});
        end
    end
    temp = fgetl(fd);
end



%% read in pulse_ekko data
%open file for reading
fid = fopen([filename(1:end-2),'DT1'], 'r');

%preallocate array
data = zeros(snum,tnum);

for kk=1:tnum;
    header = fread(fid,25,'float32');
    comment = fread(fid,28, 'char')';
    traceheaders.TraceNumbers(1,kk)=header(1,1);
    traceheaders.Positions(1,kk)=header(2,1);
    traceheaders.NumberOfPointsPerTrace(1,kk)=header(3,1);
    traceheaders.Topography(1,kk)=header(4,1);
    traceheaders.NumberOfBytesPerPoint(1,kk)=header(6,1);
    traceheaders.NumberOfStacks(1,kk)=header(8,1);
    traceheaders.TimeWindow(1,kk)=header(9,1);
    traceheaders.PosX(1,kk)=header(10,1);
    traceheaders.PosY(1,kk)=header(12,1);
    traceheaders.PosZ(1,kk)=header(14,1);
    traceheaders.RX(1,kk)=header(15,1);
    traceheaders.RY(1,kk)=header(16,1);
    traceheaders.RZ(1,kk)=header(17,1);
    traceheaders.TX(1,kk)=header(18,1);
    traceheaders.TY(1,kk)=header(19,1);
    traceheaders.TZ(1,kk)=header(20,1);
    traceheaders.TimeZeroAdjustment(1,kk)=header(21,1);
    traceheaders.ZeroFlag(1,kk)=header(22,1);
    traceheaders.TimeOfDay(1,kk)=header(24,1);
    traceheaders.CommentFlag(1,kk)=header(25,1);
    traceheaders.Comment(1,kk)=comment(1,1);
    data(:,kk)=fread(fid,snum,'int16');
end

fclose(fid);

clearvars kk fid header comment ans

%% set some preliminary stodeep variables that don't need geocoding

%only one channel here
chan = 1;
%trace number
trace_num = 1:1:tnum;

dt = window/snum*10^-9; %nanoseconds
%two-way travel time
travel_time = (dt*1e6:dt*1e6:window/1000)'; %microseconds
clear window

%trigger variables
%trigger position -- not same for whole dataset, query hearder file
trig = round(str2double(trig));
%trigger level -- not sure, transmit pulse is 180V, probably doesn't matter
trig_level = zeros(1,tnum);

%set flags structure
flags.batch = 0; flags.bpass = 0; flags.hfilt = 0; flags.rgain = 0; 
flags.agc = 0; flags.restack = 0; flags.reverse = 0; flags.crop = 0; 
flags.nmo = 0; flags.interp = 0;  flags.mig = 0; flags.elev = 0; 

%% read in NMEA GPGGA string
%Sentence Identifier	$GPGGA	Global Positioning System Fix Data
%Time: hh:mm:ss	
%Latitude: decimal degrees, hemisphere
%Longitude: decimal degreres, hemisphere
%Fix Quality: 0 (invalid), 1=GPS fix, 2=DGPS fix
%Number of Satellites
%Horizontal Dilution of Precision (HDOP) (m)
%Altitude: meters above mean sea level
%Height of geoid above WGS84 ellipsoid (meters)
%Time since last DGPS update
%DGPS reference station id	blank	No station id
%Checksum 

fclose(fd);

%gps filename and structure 
gpsname = [filename(1:end-2),'GPS'];
fd = fopen(gpsname);

%sort gps by trace number and other fields
%trace number


temp = [0 0];
tr_counter = 1;
pos_counter1 = 1;
pos_counter2 = 1;

temp = fgetl(fd);
while length(temp) ~= 1
    if temp(1:2) == 'Tr';
        strs = strsplit(temp,{' ','#'});
        gpstrace(tr_counter) = eval(strs{2});
        tr_counter = tr_counter+1;
    elseif temp(1:6) == '$GPRMC'
        strs = strsplit(temp,{',','.'});
        [trash ref_str] = strcmp_ndh(strs,'A');
        if strs{ref_str+3} == 'S';
            lat(pos_counter1) = -1*(eval(strs{ref_str+1}(1:end-2))+eval(strs{ref_str+1}(end-1:end))/60+eval(strs{ref_str+2})*10^-8/60);
        else
            lat(pos_counter1) = (eval(strs{ref_str+1}(1:end-2))+eval(strs{ref_str+1}(end-1:end))/60+eval(strs{ref_str+2})*10^-8/60);
        end
        if strs{ref_str+6} == 'W'
            long(pos_counter1) = -1*(eval(strs{ref_str+4}(1:end-2))+eval(strs{ref_str+4}(end-1:end))/60+eval(strs{ref_str+5})*10^-8/60);
        else
            long(pos_counter1) = (eval(strs{ref_str+4}(1:end-2))+eval(strs{ref_str+4}(end-1:end))/60+eval(strs{ref_str+5})*10^-8/60);
        end
        pos_counter1 = pos_counter1+1;
    elseif temp(1:6) == '$GPGGA'
        strs = strsplit(temp,{',','.'});
        [trash ref_str] = strcmp_ndh(strs,'M');
        ref_str = ref_str(1);
        if strs{6} == 'S';
            lat2(pos_counter1) = -1*(eval(strs{ref_str-12}(1:end-2))+eval(strs{ref_str-12}(end-1:end))/60+eval(strs{ref_str-11})*10^-8/60);
        else
            lat2(pos_counter1) = (eval(strs{ref_str-12}(1:end-2))+eval(strs{ref_str-12}(end-1:end))/60+eval(strs{ref_str-11})*10^-8/60);
        end
        if strs{9} == 'W'
            long2(pos_counter1) = -1*(eval(strs{ref_str-9}(1:end-2))+eval(strs{ref_str-9}(end-1:end))/60+eval(strs{ref_str-8})*10^-8/60);
        else
            long2(pos_counter1) = (eval(strs{ref_str-9}(1:end-2))+eval(strs{ref_str-9}(end-1:end))/60+eval(strs{ref_str-8})*10^-8/60);
        end
        elev(pos_counter2) = eval(strs{ref_str-2})+eval(strs{ref_str-1})*10^-3;
        pos_counter2 = pos_counter2+1;
    end
    temp = fgetl(fd);
end


%interpolate variables to traces
if length(gpstrace) > 1
lat = interp1(gpstrace,lat,trace_num,'linear','extrap');
long = interp1(gpstrace,long,trace_num,'linear','extrap');
elev = interp1(gpstrace,elev,trace_num,'linear','extrap'); 
%decday interpolation with just lower spacing by 1/2 for skipped seconds
%purely linearly interpolate from start to end
%decday = linspace(min(decday),max(decday),tnum);
end

%%
%UTM coordinates for distance calculations
if abs(mean(lat)) < 60
    z1 = utmzone(mean(lat),mean(long));
    [ellipsoid,~] = utmgeoid(z1);
    utmstruct = defaultm('utm');
    utmstruct.zone = z1;
    utmstruct.geoid = ellipsoid;
    utmstruct = defaultm(utmstruct);
    [x_coord,y_coord] = mfwdtran(utmstruct,lat,long);
else
    [x_coord y_coord] = polarstereo_fwd(lat,long);
end

%calculate 2d distance vector -- to be recalculated; for now from NMEA $GPGGA
dist = [0 cumsum(sqrt(diff(x_coord).^2+diff(y_coord).^2))];

%trace interval -- again redo, from NMEA
trace_int = [mean(diff(dist)) diff(dist)];

%pressure for ad-hoc elevation, but no altimeter here
pressure = zeros(1,tnum);

clearvars gps* utmstruct z1 ans ellipsoid hdname kgps_indx
%% save data
sflag = 'n';
if sflag == 'y'
    sname = input('Filename to save (w/o .mat)? ','s');
    save([sname '.mat'],'chan','data','dist','dt','elev',...
        'flags','lat','long','pressure','snum','tnum','trace_int',...
        'trace_num','travel_time','trig','trig_level','x_coord','y_coord');
end
