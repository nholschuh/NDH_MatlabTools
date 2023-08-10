function subset_ICESat2_Data(search_box,savename,revnum,cycle_num,ant0_or_gre1,rerun_flags);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% search_box - the polygon 
% savename - The output file name for saving the data
% revnum - the revision number, default to 205
% ant0_or_gre1 - for data in Antarctica [0] or Greenland (1)
% rerun_flags - this allows you to rerun specific subsets of the extraction
%               [1 x 2 matrix, with a 1 or 0 in each position to run:]
%                1 - 
%                2 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('ant0_or_gre1') == 0
 ant0_or_gre1 = 0;
end
if exist('revnum') == 0
    revnum = 205;
end
if exist('revnum') == 0
    cycle_num = 1;
end
if exist('revnum') == 0
    rerun_flags = [1 1 1];
end


if length(revnum) == 0
    revnum = 205;
end


%%%%%%%%%%%%%%%%%%% The directory containing the kml_information
rootdir = ['D:/Users/Nick/Google_Drive/Research_Projects/34_IceSat2/IS2_GroundTracks/'];
ddir = [rootdir,'IS2_RGTs_cycle',num2str(cycle_num),'_date_time/'];
kmls = dir([ddir,'*.kml']);

if rerun_flags(1) == 1
store_counter = 1;
keep_data = struct();
months = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];

%%%%%%%%%%%%%%%%%%% Here we loop through the kml files to try and find the
%%%%%%%%%%%%%%%%%%% time associated with data in the box
for i = 1:length(kmls)
    
   data = kml2struct([ddir,kmls(i).name]); 
   
   plat = [];
   plon = [];
   ptime = [];
    
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
    
    
    lat = data(1).Lat;
    lon = data(1).Lon;
    if ant0_or_gre1 == 0
       kinds = find(lat < 0); 
    else
       kinds = find(lat > 0);
    end
    
    tinds = find_nearest_xy([lon lat],[plon' plat']);
    ts = interp1(tinds,ptime,1:length(data(1).Lat));
    ts = ts(kinds);
    
    
    [x y] = polarstereo_fwd(lat(kinds),lon(kinds));
    
    ki = find(within(x,y,search_box(:,1),search_box(:,2)));
    
    if length(ki) > 0
        keep_data(store_counter).gt = i;
        keep_data(store_counter).xy = [x(ki) y(ki)];
        keep_data(store_counter).time = ts(ki);
        
        store_counter = store_counter+1;
    end
    disp(['Completed GT ',num2str(i),' of ',num2str(length(kmls))])
end
else
    load([savename,'_cycle',num2str(cycle_num)]);
end


%%%%%%%%%%%% At this stage, you have the times associated with your box in
%%%%%%%%%%%% each ground track

%%%%%%%%% Here we do the ATL06 cross references
if rerun_flags(2) == 1
disp(['started file fraction determination'])
atl06_fname = [rootdir,'atl06_v',num2str(revnum),'_filelist.txt'];
fid = fopen(atl06_fname);
starts6 = [];
ends6 = [];
counter = 1;
fid = fopen(atl06_fname);
t1 = fgetl(fid);
t2 = fgetl(fid);
counter = 1;
while length(t2) > 1
    
    fname{counter} = t1;
    starts6(counter) = datenum(eval(t1(7:10)), ...
            eval(t1(11:12)), ...
            eval(t1(13:14)), ...
            eval(t1(15:16)), ...
            eval(t1(17:18)), ...
            eval(t1(19:20)));

    shifts = 0;
    ends6(counter) = datenum(eval(t2(7:10)), ...
            eval(t2(shifts+[11:12])), ...
            eval(t2(shifts+[13:14])), ...
            eval(t2(shifts+[15:16])), ...
            eval(t2(shifts+[17:18])), ...
            eval(t2(shifts+[19:20])));
    
    if ends6(counter)-starts6(counter) > 350/60/60/24;
        ends6(counter) = starts6(counter)+datenum(0,0,0,0,0,350);
    end
    
    counter = counter+1;
    t1 = t2;
    t2 = fgetl(fid);
end


for i = 1:length(keep_data)
    fis = find(starts6 < keep_data(i).time(1));
    if length(fis) > 0
        fis = fis(end);
        fie = find(starts6 < keep_data(i).time(end));
        if length(fie) == 0
            fie = fis;
        else
            fie = fie(end);
        end
        
        if 0
            hold off
            plot(starts6,'o')
            plot_indicator_lines(keep_data(i).time(1),1,'black');
            plot_indicator_lines(keep_data(i).time(end),1,'black')
        end
        
        %%%%%%%%%% Expected file duration ~350s, find those data that fall
        %%%%%%%%%% within twice that value
        if (abs(keep_data(i).time(1)-starts6(fis)) < 700/(60*60*24) & ...
                abs(keep_data(i).time(end)-starts6(fie)) < 700/(60*60*24));
            
            if fie-fis == 0
                dt = ends6(fie)-starts6(fie);
                st = starts6(fie);
                keep_data(i).fracs = ([keep_data(i).time(1) keep_data(i).time(end)]-st)/dt;
            else
                keep_data(i).fracs = [zeros(fie-fis+1,1) ones(fie-fis+1,1)];
                dt = ends6(fis)-starts6(fis);
                st = starts6(fis);
                keep_data(i).fracs(1,1) = ([keep_data(i).time(1)]-st)/dt;
                dt = ends6(fie)-starts6(fie);
                st = starts6(fie);
                keep_data(i).fracs(end,2) = ([keep_data(i).time(end)]-st)/dt;
            end
            
            keep_data(i).fnames = fname(fis:fie);
        else
            keep_data(i).fnames = '';
        end
    end
end
disp(['ended'])
end

save([savename,'_cycle',num2str(cycle_num)],'keep_data');
end















