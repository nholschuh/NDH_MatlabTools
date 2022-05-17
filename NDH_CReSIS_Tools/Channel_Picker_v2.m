function picks = Channel_Picker_v2(input_file,save_prefix);
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% This function was designed for an undergraduate project centered around
% picking basal crevasse locations and their sizes. It was subsequently
% modified to pick crevasse tips in data from Crary Ice Rise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% input_file - the name of the matlab file containing the original data.
%              This script should be run from the directory where that data
%              is stored.
%
% save_prefix - this is the prefactor added to the savename for the file
%              containing the results. If nothing is entered, the default is
%              'Channel_PXB_'
%
% pick_file - this is the name for a file containing a bed pick, for used
%             in measuring crevasse height
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
cice_import

if exist('save_prefix') == 0
    save_prefix = 'Picks_';
end


if isstr(input_file)
    if str_contain(input_file,'mig') == 1
        %%%% An example name - PickableData_20131226_11_006_mig.mat
        sto_flag = 1;
        savename = [save_prefix,input_file(14:end-8),'.mat']
        eval(input_file(end-6:end-4))
    else
        %%%% An example name - Data_20131226_11_006.mat
        sto_flag = 0;
        savename = [save_prefix,input_file(6:end)];
    end
    
    load(input_file)
    time_flag = 1;
    if sto_flag == 1
        Latitude = lat;
        Longitude = long;
        Elevation = elev;
        Data = migdata;
        Time = travel_time;
    end
else
    savename = [save_prefix,input_file.savename];
    stoflag = 0;
    Latitude = input_file.Latitude;
    Longitude = input_file.Longitude;
    Elevation = input_file.Elevation;
    Data = input_file.Data;
    if isfield(input_file,'Time')
        Time = input_file.Time;
        time_flag = 1;
    elseif isfield(input_file,'Depth') 
        Depth = input_file.Depth
        time_flag = 0;
    end
end


if time_flag == 1
    zaxis = Time;
elseif time_flag == 0
    zaxis = Depth;
end


if exist(savename) ~= 0;
    load(savename);
else
    picks = struct('tipdepth',[],'twtt',[],'samp_num',[],'trace_num',[],'lat',[],'lon',[],'x',[],'y',[],'fname',input_file);
end


%%%%%%%%%%%%%%%%%%%%%%%%%
[x y] = polarstereo_fwd(Latitude,Longitude);

hold off
if time_flag == 1
    imagesc(1:length(Data(1,:)),zaxis,lp(Data));
    set(gca,'YDir','reverse')
else
    imagesc(1:length(Data(1,:)),zaxis,Data);
    set(gca,'YDir','normal')
end

colormap(gray)
colorbar
hold all

if length(picks.x) > 0
    plot([picks.trace_num], [picks.twtt], 'o','Color','red')
end

maximize()
% disp('Take a moment to adjust the figure zoom and color, then type ''dbcont'' to continue')
% disp('     Colormap Editing - caxis([ low_value high_value ])')
% disp('')
% %keyboard
disp('Picker Commands')
disp('  click - select point')
disp('  q - end selection')
disp('  u - undo previous selection')

[crevasse_picks] = graphical_selection(2);

trace_num = round(crevasse_picks(:,1));
twtt = crevasse_picks(:,2);
dt = zaxis(2)-zaxis(1);

if length(crevasse_picks) > 0
    if time_flag == 1
        picks.twtt = [picks.twtt; twtt];
    else
        picks.tipdepth = [picks.tipdepth; twtt];
    end
    picks.samp_num = [picks.samp_num; find_nearest(zaxis,crevasse_picks(:,2))];
    picks.trace_num = [picks.trace_num; trace_num];
    picks.lat = [picks.lat; Latitude(trace_num)'];
    picks.lon = [picks.lon; Longitude(trace_num)'];
    picks.x = [picks.x; x(trace_num)];
    picks.y = [picks.y; y(trace_num)];
else
    if time_flag == 1
        picks.twtt = [picks.twtt; []];
    else
        picks.tipdepth = [picks.tipdepth; []];
    end
    picks.samp_num = [picks.samp_num; []];
    picks.trace_num = [picks.trace_num; []];
    picks.lat = [picks.lat; []];
    picks.lon = [picks.lon; []];
    picks.x = [picks.x; []];
    picks.y = [picks.y; []];
end

save(savename,'picks')


