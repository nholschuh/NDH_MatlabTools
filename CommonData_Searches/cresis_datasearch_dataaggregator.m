function cresis_datasearch_dataaggregator(filenames,remove_totaldata,subset_by_outline,constraining_poly,outname)
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% This file is designed to work with the cresis_datasearch function. This
% takes the list of files provided by the original search criteria and
% writes the data out to a file for later use.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Necessary Inputs
% filenames - first output from "cresis_datasearch", a list of file names
%           to read in and aggregate
% remove_totaldata - 0 for keep the original radargrams, [1] for exclude
% subset_by_outline - 0 keeps all data within the files that pass through
%           your region of interest, [1] results in only data within the region
% constraining_poly - the second output from "cresis_datasearch", it is the
%           polygon of interest that subsets the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% For Testing Purposes

if exist('remove_totaldata') == 0
    remove_totaldata = 0;
end

if exist('constraining_poly') == 0
    constraining_poly = 0;
    subset_by_outline = 0;
end
if length(constraining_poly) == 0
    constraining_poly = 0;
    subset_by_outline = 0;
end

if exist('subset_by_outline') == 0
    subset_by_outline = 0;
end

if exist('outname') == 0
    outname = [];
end

if length(outname) == 0
    dd = date;
    olx = round_to([min(constraining_poly(:,1)) max(constraining_poly(:,1))],1000)/1000;
    oly = round_to([min(constraining_poly(:,2)) max(constraining_poly(:,2))],1000)/1000;
    savename = ['DataSearch_',dd(1:2),'_',dd(4:6),'_',dd(8:11),'_ol',num2str(olx(1)),'x',num2str(oly(1)),'y_',num2str(olx(2)),'x',num2str(oly(2)),'y'];
else
    savename = ['DataSearch_',outname];    
end

start_indecies = [];

AggregatedData = {};
AggregatedData_inds = [];
Data_Vals = [];
start_indecies = [1];
filename_ymd = {};


tic
for i = 1:length(filenames)
    try
        if isstruct(filenames)
            load(filenames(i).name);
        else
            load(filenames{i});
        end

        if remove_totaldata == 0
            [x y] = polarstereo_fwd(Latitude,Longitude);
            dists = distance_vector(x,y);
            AggregatedData_inds = [AggregatedData_inds; ones(length(Data(1,:)),1)*i];
            AggregatedData{i,1} = [dists];
            AggregatedData{i,2} = [Time];
            AggregatedData{i,3} = [Data];
        end


        if exist('Surface') == 1
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
            [bed_elev surface_elev] = pickelevation(Elevation,surface_index,bed_index,Time);
        else
            bed_index = zeros(size(elevation))*Nan;
            bed_elev = zeros(size(elevation))'*Nan;
            surface_index = zeros(size(elevation))*Nan;
            surface_elev = zeros(size(elevation))'*Nan;
        end

        [x y] = polarstereo_fwd(Latitude,Longitude);

        if isstruct(filenames)
            file_info = strsplit(filenames(i).name,'_');
        else
            file_info = strsplit(filenames{i},'_');
        end

        for k = 1:length(file_info)
            if length(file_info{k}) == 8
                if str_contain(file_info{k},'\') == 0 & str_contain(file_info{k},'/') == 0
                    break
                end
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


        Data_Vals = [Data_Vals; [x' y' Latitude' Longitude' Elevation' surface_index' surface_elev bed_index' bed_elev [1:length(x)]' subline_index line_index day month year]];
        filename_ymd{i,1} = [subline_index(1) line_index(1) day(1) month(1) year(1)];

        if isstruct(filenames)
            filename_ymd{i,2} = [filenames(i).name];
        else
            filename_ymd{i,2} = [filenames{i}];
        end

        if i < length(filenames)
        start_indecies = [start_indecies start_indecies(i)+length(x)];
        end

        disp(['Collected data from file ',num2str(i),' of ',num2str(length(filenames)),' - ',num2str(round_to(toc,0.1)),'s'])
    catch
        if isstruct(filenames)
            disp([' ----- error with ',filenames(i).name])
        else
            disp([' ----- error with ',filenames{i}]);
        end
        
    end
end

%start_indecies = start_indecies(1:(length(start_indecies)-1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Here we used the provided outline or grid to exclude some data
%%%%%%%%%% from the files read, if selected
if subset_by_outline == 1
   if remove_totaldata == 0
       start_indecies = [1];
       for i = 1:length(AggregatedData)
           inds = find(AggregatedData_inds == i);
           
           %%%%%%%%% here we subset by either an outline or by a matrix
           if iscell(constraining_poly) == 0
               ki = find(within(Data_Vals(inds,1),Data_Vals(inds,2),constraining_poly(:,1),constraining_poly(:,2)));
           else
               ingrid = matsearch(Data_Vals(inds,1:2),constraining_poly{1},constraining_poly{2},constraining_poly{3});
               ki = find(ingrid == 1);
           end
           
           if length(ki) > 0
                AggregatedData{i,1} = AggregatedData{i,1}(ki) - AggregatedData{i,1}(ki(1));
                AggregatedData{i,3} = AggregatedData{i,3}(:,ki);
           else
               AggregatedData{i,1} = [];
               AggregatedData{i,3} = [];
           end
           start_indecies = [start_indecies start_indecies(i)+length(AggregatedData{i,1})];    
       end
   end
   
   if iscell(constraining_poly) == 0
       ki = find(within(Data_Vals(:,1),Data_Vals(:,2),constraining_poly(:,1),constraining_poly(:,2)));
   else
       ingrid = matsearch(Data_Vals(:,1:2),constraining_poly{1},constraining_poly{2},constraining_poly{3});
       ki = find(ingrid == 1);       
   end
   
   Data_Vals = Data_Vals(ki,:);
   if remove_totaldata == 0
        AggregatedData_inds = AggregatedData_inds(ki);
   end
end


DV_info = {'x_coord','y_coord','latitude','longitude','flight_elevation','surface_pick','surface_elevation','bed_pick','bed_elevation','trace_id','segment','flightline','day','month','year'};


savestring = ['save ',savename,'.mat AggregatedData Data_Vals DV_info start_indecies Time filename_ymd constraining_poly'];

if exist('Time') == 1
    eval(savestring)
else
    disp('No data in the region')
end
    
end





