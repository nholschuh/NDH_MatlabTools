function keep_data = find_IS2_GTs(search_box,ant0_or_gre1,cycle_num,time_include);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% This function will read in reference ground tracks for a given cycle and
% determine which ground tracks fall within a supplied bounding box
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% bounding_box -
% cycle_num -
% inp3 -
% inp4 -
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% out1 -
% out2 -
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

status_updates = 1;

if exist('cycle_num') == 0
    cycle_num = 2;
end
if exist('ant0_or_gre1') == 0
    ant0_or_gre1 = 0;
end
if exist('time_include') == 0
    time_include = 0;
end

ddir = [OnePath,'Research_Projects/34_IceSat2/IS2_GroundTracks/IS2_RGTs_cycle',num2str(cycle_num),'_date_time/'];
kmls = dir([ddir,'*.kml']);


store_counter = 1;
keep_data = struct();
months = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];

for i = 1:length(kmls)
    
    data = kml2struct([ddir,kmls(i).name]);
    
    plat = [];
    plon = [];
    ptime = [];
    
    %keyboard
    
    if time_include == 1
        %%%%%%%%%% first interpolate the times, and convert them to "delta
        %%%%%%%%%% time"
        
        for j = 2:length(data)
            plat(j-1) = data(j).Lat;
            plon(j-1) = data(j).Lon;
            
            
            td = data(j).Description;
            lbs = find(td == char(10));
            lbs = [0 lbs length(td)+1];
            
            %%%%% Find the year
            h = eval(td(lbs(2)+1+[12:13]));
            mn = eval(td(lbs(2)+1+[15:16]));
            s = eval(td(lbs(2)+1+[18:19]));
            y = eval(td(lbs(2)+1+[7:10]));
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% Find the day, using doy (only cycles >= 2)
            % d_inds = find(isstrprop(td(lbs(3)+1:lbs(4)-1),'digit'));
            % d = eval(td(lbs(3)+d_inds));
            % m = 0;
            
            m_string = td(lbs(2)+1+[3:5]);
            m = find(m_string(1) == months(:,1) & m_string(2) == months(:,2) & m_string(3) == months(:,3));
            d = eval(td(lbs(2)+0+[1:2]));
            
            ptime(j-1) = datenum(y,m,d,h,mn,s);
        end
        
        st = ptime(1);
        et = ptime(end);
        dt = et-st;
    end
    
    lat = data(1).Lat;
    lon = data(1).Lon;
    if ant0_or_gre1 == 0
        kinds = find(lat < 0);
    else
        kinds = find(lat > 0);
    end
    
    
    %%%%%%%%%%%%%%%% Time interpolation
    if time_include == 1
        tinds = find_nearest_xy([lon lat],[plon' plat']);
        ts = interp1(tinds,ptime,1:length(data(1).Lat));
        ts = ts(kinds);
    end
    
    
    [x y] = polarstereo_fwd(lat(kinds),lon(kinds));
    
    ki = find(within(x,y,search_box(:,1),search_box(:,2)));
    
    if length(ki) > 0
        keep_data(store_counter).gt = i;
        keep_data(store_counter).xy = [x(ki) y(ki)];
        
        if time_include == 1
            keep_data(store_counter).time = ts(ki);
        end
        
        store_counter = store_counter+1;
    end
    
    if status_updates == 1
        if mod(i,200) == 0
        disp(['Completed GT ',num2str(i),' of ',num2str(length(kmls))])
        end
    end
end











