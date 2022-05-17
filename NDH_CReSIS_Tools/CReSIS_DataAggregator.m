function CReSIS_DataAggregator(prefix,remove_totaldata,savename,filerange,directory_addon,separate_pick_prefix,depthcap)
% Aggregates all CReSIS data in the present working directory. If you wish
% to use subdirectories, include their names in the directory_addon input.
% any values for If_depth_surface indicate that this cresis data stores the surface and
% bed picks as depths instead of times, and calculates them accordingly.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Necessary Inputs
% prefix - Either a string, containing the first desired characters after
%          Data_, or a 0, indicating you want all cresis data in the
%          directory
% remove_totaldata - This will only collect the metadata, not the full data
%          matrix.
% directory_addon - This allos you to specify an alternate directory to run
% depthcap - a sample number to truncate data after
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% For Testing Purposes

currentdirectory = pwd;
if exist('directory_addon') == 1 && directory_addon(1) ~= 0
    dirparts = strsplit(directory_addon);
    [a b c] = fileparts(dirparts{end});
else
    [a b c] = fileparts(currentdirectory);
end
filestart = b(1);


if prefix == 0
    if exist('directory_addon')==1 && directory_addon(1) ~= 0
        currentdirectory = [currentdirectory '\' directory_addon];
        files_list = dir(['.\',directory_addon,'\Data_',filestart,'*']);
    else
        files_list = dir(['Data_',filestart,'*']);
    end
else
    if exist('directory_addon')==1 && directory_addon(1) ~= 0
        currentdirectory = [currentdirectory '\' directory_addon];
        files_list = dir(['.\',directory_addon,'\Data_',prefix,'_*']);
    else
        files_list = dir(['Data_',prefix,'*']);
    end
end

if exist('separate_pick_prefix') == 0
    separate_pick_prefix = 0;
end

%%%%%% This section loads in pick files with the same structure
if length(separate_pick_prefix) > 1
    if prefix == 0
        if exist('directory_addon')==1
            currentdirectory = [currentdirectory '\' directory_addon];
            pick_files = dir(['.\',directory_addon,'\',separate_pick_prefix,'_',filestart,'*']);
        else
            pick_files = dir([separate_pick_prefix,'_',filestart,'*']);
        end
    else
        if exist('directory_addon')==1
            currentdirectory = [currentdirectory '\' directory_addon];
            pick_files = dir(['.\',directory_addon,'\',separate_pick_prefix,'_',prefix,'_*']);
        else
            pick_files = dir([separate_pick_prefix,'_',prefix,'_*']);
        end
    end
end

if length(files_list) == 0
    files_list = dir(['Data*.mat']);
end

if exist('filerange') == 1
    files_list = files_list(filerange);
end

if strfind(prefix,'img')
    if exist('directory_addon')==1 
        currentdirectory = [currentdirectory '\' directory_addon];
        extrafile = dir(['.\',directory_addon,'\Data_',filestart,'*']);
        
        loadstring1 = ['load .\',directory_addon,'\',extrafile(1).name];
        eval(loadstring1);
        
        Time_basis = Time;
    else
        extrafile = dir(['Data_',filestart,'*']);
        
        loadstring1 = ['load ',extrafile(1).name];
        eval(loadstring1);
        
        Time_basis = Time;
    end
end


if exist('savename') == 0
    [upperPath, savename, ~] = fileparts(currentdirectory);
end



start_indecies = [];

AggregatedData = [];
Data_Vals = [];
start_indecies = [1];
filenames = [];
filename_ymd = {};

if length(files_list) == 0
    files_list = dir(['.\Data_img_01_',filestart,'*']);
end

for i = 1:length(files_list)
    if exist('directory_addon')==1 && directory_addon(1) ~=0
        filenames{i} = ['.\',directory_addon,'\',files_list(i).name];
    else
        filenames{i} = [files_list(i).name];
    end
    clearvars DataElevation GPS_time Heading Latitude Longitude Pitch Roll Surface Bottom Time file_version param* 
    load(filenames{i});
    disp(filenames{i});
    
    
    
    if exist('Time_basis') == 1
        Timetest = abs(Time-Time_basis(1));
        timestart = find(min(Timetest) == Timetest);
        timeend = timestart+length(Time_basis)-1;
        Data = Data(timestart:timeend,:);
        Time = Time(timestart:timeend);
    end
    
    
    if exist('depthcap') == 0
        if remove_totaldata == 0
            AggregatedData = [AggregatedData Data];
        end
    else
        if depthcap == 0
            depthcap = length(Data(:,1));
        end
        if remove_totaldata == 0
            AggregatedData = [AggregatedData Data(1:depthcap,:)];
        end
    end
    
    if length(separate_pick_prefix) > 1
        if exist('directory_addon')==1
            loadstring = ['load .\',directory_addon,'\',pick_files(i).name];
        else
            loadstring = ['load ',pick_files(i).name];
        end
        eval(loadstring)
        Bottom = picks.samp2;
    end
    
    if exist('Surface') == 1
        if exist('Bottom') == 0
            Bottom = Surface;
        end
        if exist('if_depth_surface') == 0
            if max(Surface) < 1
                surface_index = time2index(Surface,Time);
            else
                surface_index = Surface;
            end
            
            if max(Bottom) < 1
                bed_index = time2index(Bottom,Time);
            else
                bed_index = Bottom;
            end
        else
            surface_index = time2index(Surface,Depth);
            bed_index = time2index(Bottom,Depth);
        end
        if max(bed_index == Inf) == 1
            bed_index = zeros(size(Elevation))*NaN;
            bed_elev = zeros(size(Elevation))'*NaN;
            surface_index = zeros(size(Elevation))*NaN;
            surface_elev = zeros(size(Elevation))'*NaN;
        else
            [bed_elev surface_elev] = pickelevation(Elevation,surface_index,bed_index,Time);
        end
    else
        bed_index = zeros(size(elevation))*NaN;
        bed_elev = zeros(size(elevation))'*NaN;
        surface_index = zeros(size(elevation))*NaN;
        surface_elev = zeros(size(elevation))'*NaN;
    end
    
    [x y] = polarstereo_fwd(Latitude,Longitude);

    
    file_info = strsplit(files_list(i).name,'_');
    for k = 1:length(file_info)
        if length(file_info{k}) == 8
            break
        end
    end
    
    if length(file_info) < k+2
         k = length(file_info)-2;
    end
    subline_index_num = strsplit(file_info{k+2},'.');

    subline_index = ones(size(bed_elev))*eval(subline_index_num{1});
    line_index = ones(size(bed_elev))*eval(file_info{k+1});
    day = ones(size(bed_elev))*eval(file_info{k}(7:8));
    month = ones(size(bed_elev))*eval(file_info{k}(5:6));
    year = ones(size(bed_elev))*eval(file_info{k}(1:4));

    
    Data_Vals = [Data_Vals; [x' y' Latitude' Longitude' Elevation' surface_index' surface_elev bed_index' bed_elev [1:length(x)]' subline_index line_index day month year GPS_time']];
    filename_ymd{i,1} = [subline_index(1) line_index(1) day(1) month(1) year(1)]; 
    filename_ymd{i,2} = [currentdirectory,'\',filenames{i}];
    start_indecies = [start_indecies start_indecies(i)+length(Data(1,:))];
end

%start_indecies = start_indecies(1:(length(start_indecies)-1));

DV_info = {'x_coord','y_coord','latitude','longitude','flight_elevation','surface_pick','surface_elevation','bed_pick','bed_elevation','trace_id','segment','flightline','day','month','year','GPS_Time'};

if prefix == 0
    savestring = ['save ',savename,'_Aggregated.mat AggregatedData Data_Vals DV_info start_indecies Time filename_ymd'];
else
    savestring = ['save ',prefix,'_',savename,'_Aggregated.mat AggregatedData Data_Vals DV_info start_indecies Time filename_ymd'];
end

eval(savestring)
end
    
    



