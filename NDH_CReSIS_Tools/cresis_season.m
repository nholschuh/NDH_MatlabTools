function [s_prefix ant_or_gre] = cresis_season(y,m,d);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Identifies the season prefix based on dates of acquisition;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% y - The year of acquisition (or a cresis filename)
% m - The month of acquisition
% d - The day of acquisition
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% s_prefix - The file name for the season of interest
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if isstr(y) == 1
    d = eval(y(12:13));
    m = eval(y(10:11));
    y = eval(y(6:9));
end


%%%%%%%%%%%%%%%%% This is the initial step, required to be run once to
%%%%%%%%%%%%%%%%% compile the season info
compile_seasoninfo = 0;

if compile_seasoninfo == 1
    for jj = 1
    %%%%%%%%%%%%% Aggregate the Antarctica Dates
    a_dates = [];
    
    cd('E:\Graduate_Work\Data\CReSIS_Bulk_Download\Antarctica')
    
    a_names = folders();
    a_names = a_names(1:end-1);
    
    files = dir('2*.mat');
    
    
    for i = 1:length(files);
        load(files(i).name);
        dates{i} = datenum(Data_Vals2(:,15),Data_Vals2(:,14),Data_Vals2(:,13));
        dates{i} = remove_duplicates(dates{i});
        
        a_dates = [a_dates; [dates{i} ones(size(dates{i}))*i]];
    end    

    %%%%%%%%%%%%%%%%%% Debug Plot
%     hold off
%     colors = jet(length(files));
%     for i = 1:length(files)
%         plot(dates{i},i,'.','Color',colors(i,:))
%         hold all
%     end
    
     %%%%%%%%%%%%% Aggregate the Greenland Dates
    g_dates = [];
    
    cd('E:\Graduate_Work\Data\CReSIS_Bulk_Download\Greenland')
    
    g_names = folders();
    g_names([19 26]) = [];
    
    files = dir('1*.mat');
    files = [files; dir('2*.mat')];
    
    
    for i = 1:length(files);
        load(files(i).name);
        dates{i} = datenum(Data_Vals2(:,15),Data_Vals2(:,14),Data_Vals2(:,13));
        dates{i} = remove_duplicates(dates{i});
        
        g_dates = [g_dates; [dates{i} ones(size(dates{i}))*i]];
    end    

    %%%%%%%%%%%%%%%%%% Debug Plot
%     hold off
%     colors = jet(length(files));
%     for i = 1:length(files)
%         plot(dates{i},i,'.','Color',colors(i,:))
%         hold all
%     end   
    
    clearvars -except a_dates g_dates a_names g_names
    
    save([OnePath,'Matlab_Code\NDH_Tools\NDH_CReSIS_Tools\season_metadata.mat'],'a_dates','g_dates','a_names','g_names')
    end
else
    load season_metadata.mat
end

searchdate = datenum(y,m,d);

full_dates = [a_dates ones(size(a_dates(:,1))); g_dates ones(size(g_dates(:,1)))*2];
datematch = find(searchdate == full_dates(:,1));

if length(datematch) == 0
    disp('No seasons match the provided date')
    s_prefix = [];
    ant_or_gre = [];
else
    if full_dates(datematch,3) == 1
        s_prefix = a_names(full_dates(datematch,2)).name;
        ant_or_gre = 1;
    else
        s_prefix = g_names(full_dates(datematch,2)).name;
        ant_or_gre = 2;
    end
end




end





