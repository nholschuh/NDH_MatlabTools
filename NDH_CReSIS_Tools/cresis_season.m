function [s_prefix ant_or_gre] = cresis_season(y,m,d,prompt0_ant1_gre2);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Identifies the season prefix based on dates of acquisition;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% y - The year of acquisition (or a cresis filename)
% m - The month of acquisition
% d - The day of acquisition
% prompt0_ant1_gre2 - 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% s_prefix - The file name for the season of interest
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('y') == 0
    d = 0;
    m = 0;
    y = 0;
end

%%%%%%% There are a small number of flight days in which both campaigns
%%%%%%% were running apparently. By default, this code will assume you want
%%%%%%% the Antarctic Season. If you would prefer it prompt you to ask for
%%%%%%% a selection, chanage the value to zero.
if exist('prompt0_ant1_gre2') == 0
    prompt0_ant1_gre2 = 1;
end

if isstr(y) == 1
    d = eval(y(12:13));
    m = eval(y(10:11));
    y = eval(y(6:9));
end

%%
%%%%%%%%%%%%%%%%% This is the initial step, required to be run once to
%%%%%%%%%%%%%%%%% compile the season info
compile_seasoninfo = 0;

if compile_seasoninfo == 1
    for jj = 1
    %%%%%%%%%%%%% Aggregate the Antarctica Dates
    a_dates = [];
    
    if exist('F:\Graduate_Work\Data\CReSIS_Bulk_Download\Antarctica')
        cd('F:\Graduate_Work\Data\CReSIS_Bulk_Download\Antarctica')
    elseif exist('/mnt/data01/Data/RadarData/Antarctica/')
        cd('/mnt/data01/Data/RadarData/Antarctica/')
    end
    
    
    a_names = folders();
    a_names = a_names(1:end);
    
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
    
    if exist('F:\Graduate_Work\Data\CReSIS_Bulk_Download\Greenland')
        cd('F:\Graduate_Work\Data\CReSIS_Bulk_Download\Greenland')
    elseif exist('/mnt/data01/Data/RadarData/Greenland/')
        cd('/mnt/data01/Data/RadarData/Greenland/')
    end
    
    g_names = folders();
    
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
    
    clearvars -except a_dates g_dates a_names g_names y m d
    
    save([OnePath,'Matlab_Code/NDH_Tools/NDH_CReSIS_Tools/season_metadata.mat'],'a_dates','g_dates','a_names','g_names')
    end
else
    load season_metadata.mat
end
%%
searchdate = datenum(y,m,d);

full_dates = [a_dates ones(size(a_dates(:,1))); g_dates ones(size(g_dates(:,1)))*2];
datematch = find(searchdate == full_dates(:,1));

if length(datematch) == 0
    disp('No seasons match the provided date')
    s_prefix = [];
    ant_or_gre = [];
else
    s_prefix = [];
    ant_or_gre = [];
    for i = 1:length(datematch)
        if full_dates(datematch(i),3) == 1
            s_prefix{i} = a_names(full_dates(datematch(i),2)).name;
            ant_or_gre(i) = 1;
        else
            s_prefix{i} = g_names(full_dates(datematch(i),2)).name;
            ant_or_gre(i) = 2;
        end
    end
    if length(ant_or_gre) > 1
        if prompt0_ant1_gre2 == 0
        season_selection = listdlg('ListString',s_prefix,'PromptString','Select the most likely season:');
        elseif prompt0_ant1_gre2 == 1
            season_selection = find(full_dates(datematch,3) == 1);
            season_selection = season_selection(1);
        else
            season_selection = find(full_dates(datematch,3) == 2);
            season_selection = season_selection(1);            
        end
        s_prefix = s_prefix{season_selection};
        ant_or_gre = ant_or_gre(season_selection);
    else
        s_prefix = s_prefix{1};
        ant_or_gre = ant_or_gre(1);
    end
end




end





