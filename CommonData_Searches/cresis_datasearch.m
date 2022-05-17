function [file_list ol] = cresis_datasearch(ant0_or_gre1,point0_outline1_grid2,location_input,remove_totaldata,subset_by_outline,name_prefix)
% (C) Nick Holschuh - UW - 2017 (Nick.Holschuh@gmail.com)
% This file reads into the "CReSIS_Sectors_forDataSearch.mat" file to
% identify which data fall within 10km blocks, reads in data from those
% files, and subsets it based on the original demands of the inquiry. The
% CReSIS_Sectors_forDataSearch.mat file was produced by the
% "Write_SectorFiles.m" script. The data will write out a data file with a
% name associated with todays date and the outline edges.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% ant0_or_gre1 - selecting data in Antarctica or Greenland
%
% point0_outline1_grid2 - this allows you to supply a point target [0], supply
%       or produce an outline of a region [1], or provide a grid mask [2]
%       that will be used to subset the radar data. Each of these options
%       rely on an argument in the location_input object.
%
% location_input - 
%       if 0 - a three element vector, with the x/y coordinates and the
%       search radius to include
%       if 1 - either an empty array [] if you want to select the outline
%       graphically, or a 5x2 matrix with the outline of a region to search
%       if 2 - a 1x3 cell array containing the x and y axes of a grid, and
%       a grid mask containing 0s or 1s to indicate which cells you want
%       data from
%
% remove_totaldata - 0 for keep the original radargrams, [1] for exclude
%
% subset_by_outline - 0 keeps all data within the files that pass through
%       your region of interest, [1] results in only data within the region
%
% name_prefix - A value that can be added to control the name of the output
%       file, if the date and edges are not desired.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The outputs are as follows:
%
% file_list - the list of all files that pass through your target region
% ol - the supplied outline for the data.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if exist('remove_totaldata') == 0
    remove_totaldata = 1;
end
if exist('name_prefix') == 0
    name_prefix = [];
end
if exist('subset_by_outline') == 0
    subset_by_outline = 1;
end

if exist('location_input') == 0
    location_input = 0;
end

if location_input == 0;
    location_input = [];
end


%%%%%%%%%% Here we test several drive possibilities

if exist('F:/Graduate_Work/Data/CReSIS_Bulk_Download/') == 7
    drive_letter = 'F:/';
end
if exist('D:/Graduate_Work/Data/CReSIS_Bulk_Download/') == 7
    drive_letter = 'D:/';
end
if exist('E:/Graduate_Work/Data/CReSIS_Bulk_Download/') == 7
    drive_letter = 'E:/';
end
if exist('G:/Graduate_Work/Data/CReSIS_Bulk_Download/') == 7
    drive_letter = 'G:/';
end
if exist('/mnt/data01/Data/RadarData/') == 7
    drive_letter = '';
    path_modify = '/mnt/data01/Data/RadarData/';
end

%%%%%%%%%% Here we load in the data if the right file was found
if exist('drive_letter') == 0
    disp(['The requisite drive is not found - check the path and retry'])
else
    
    
    
    if ant0_or_gre1 == 0
        %%%%%%%%%%%%% These are made by the "Write_SectorFiles" script on
        %%%%%%%%%%%%% the external drive. First you bulk aggregate, then
        %%%%%%%%%%%%% write sectorfiles, then copy this into the
        %%%%%%%%%%%%% commondatasearches folder
        load([OnePath,'Matlab_Code/NDH_Tools/CommonData_Searches/CReSIS_Data/Antarctica/CReSIS_Sectors_forDataSearch_Ant.mat'])
    else
        load([OnePath,'Matlab_Code/NDH_Tools/CommonData_Searches/CReSIS_Data/Greenland/CReSIS_Sectors_forDataSearch_Gre.mat'])
    end
    
    %%%% Here we correct for a different mount point, just in case
    if str_contain(filename{1,2},drive_letter) == 0
        if exist('path_modify') == 1
            for i = 1:length(filename)
                filename{i,2} = [path_modify,filename{i,2}(44:end)];
                rep_inds = find(filename{i,2} == '\');
                filename{i,2}(rep_inds) = '/';
            end
        else
            for i = 1:length(filename)
                filename{i,2}(1:3) = drive_letter;
            end
        end
    end
    
    
    if point0_outline1_grid2 == 0 %%%%%%%%%%% The selected point option
        cc = find_nearest(sector_x,location_input(1));
        rr = find_nearest(sector_y,location_input(2));
        
        buffer_if_point = floor(location_input(3)/sector_spacing);
        
        ol = [sector_x(cc)-sector_spacing*(1+2*buffer_if_point)/2 sector_y(rr)-sector_spacing*(1+2*buffer_if_point)/2; ...
            sector_x(cc)+sector_spacing*(1+2*buffer_if_point)/2 sector_y(rr)-sector_spacing*(1+2*buffer_if_point)/2; ...
            sector_x(cc)+sector_spacing*(1+2*buffer_if_point)/2 sector_y(rr)+sector_spacing*(1+2*buffer_if_point)/2; ...
            sector_x(cc)-sector_spacing*(1+2*buffer_if_point)/2 sector_y(rr)+sector_spacing*(1+2*buffer_if_point)/2; ...
            sector_x(cc)-sector_spacing*(1+2*buffer_if_point)/2 sector_y(rr)-sector_spacing*(1+2*buffer_if_point)/2;];
        
         bi = max([rr-buffer_if_point 1]);
         ti = min([rr+buffer_if_point length(sector_inds(:,1))]);
         bi2 = max([cc-buffer_if_point 1]);
         ti2 = min([cc+buffer_if_point length(sector_inds(1,:))]);
        
        chosen_sectors = matrix_to_vector(sector_inds(bi:ti,bi2:ti2));
        
    elseif point0_outline1_grid2 == 1 %%%% the outline option
        
        if length(location_input) == 0
            if ant0_or_gre1 == 0
                A_Velocity(1);
            else
                G_Velocity(1);
            end
            ol = graphical_selection(1);
        else
            ol = location_input;
        end
        xy = combvec(sector_x,sector_y)';
        sector_list = matrix_to_vector(sector_inds);
        chosen_sectors = sector_list(find(within(xy(:,1),xy(:,2),ol(:,1),ol(:,2))));
        
    elseif point0_outline1_grid2 == 2 %%%% the grid option
        dx = location_input{1}(2)-location_input{1}(1);
        dy = location_input{2}(2)-location_input{2}(1);
        gx = [location_input{1}(1)-dx location_input{1} location_input{1}(end)+dx];
        gy = [location_input{2}(1)-dy location_input{2} location_input{2}(end)+dy];
        nm = zeros([size(location_input{3})+2]);
        nm(2:end-1,2:end-1) = location_input{3};
        new_mask = regrid(gx,gy,nm,sector_x,sector_y,'nearest');
        
        chosen_sectors = sector_inds(find(new_mask == 1));
        ol = {gx,gy,nm};
    end
        

    
    file_ind_list = [];
    for i = 1:length(chosen_sectors);
        file_ind_list = [file_ind_list sector_files{chosen_sectors(i)}];
    end
    file_ind_list = remove_duplicates(file_ind_list);
    file_list = filename(file_ind_list,2);
    
    if length(file_list) == 0
        disp('No Files Found')
    else
        cresis_datasearch_dataaggregator(file_list,remove_totaldata,subset_by_outline,ol,name_prefix);
    end
end











