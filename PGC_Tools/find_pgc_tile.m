function tile_info = find_pgc_tile(input_xy_or_latlon,download_flag,download_dir,arctic_or_antarctic,lat_lon_flag);
% (C) Nick Holschuh - U. of Washington - 2019 (Nick.Holschuh@gmail.com)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% input_xy_or_latlon - 
% download_flag - 
% arctic_or_antarctic - 
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


%%%%%%%%%%%%% Make .mat files out of .shp files for computers without the
%%%%%%%%%%%%% mapping toolbox
if 0
    rdata = shaperead('REMA_Tile_Index_Rel1.shp');
    save('REMA_Tile_Index_Rel1.mat','rdata');
    rdata = shaperead('ArcticDEM_Tile_Index_Rel7.shp');
    save('ArcticDEM_Tile_Index_Rel7.mat','rdata');  
end


%%%%%%%%%%%% Here we initialize the variables
if exist('download_flag') == 0
    downwload_flag = 0;
end
if exist('download_dir') == 0
    download_dir = 0;
end
if download_dir == 0
    download_dir = './DEM_Tiles/';
end
if exist('arctic_or_antarctic') == 0
    arctic_or_antarctic = -1;
end
if exist('lat_lon_flag') == 0
    if max(abs(input_xy_or_latlon(:,1))) <= 90 &  max(abs(input_xy_or_latlon(:,2))) <= 360
        lat_lon_flag = 1;
    else
        lat_lon_flag = 0;
    end
end


if lat_lon_flag == 1
    if min(input_xy_or_latlon(:,1)) > 0
        arctic_or_antarctic = 1;
    else
        arctic_or_antarctic = 2;
    end    
    [x,y] = polarstereo_fwd(input_xy_or_latlon(:,1),input_xy_or_latlon(:,2));
    input_data = [x,y];
else
    input_data = input_xy_or_latlon;%%%%%%%%%%%% Here we get them all into the right Coordinate system
    if arctic_or_antarctic == -1
        arctic_or_antarctic = listdlg('ListString',{'ArcticDEM','REMA'},'PromptString','Select ArcticDEM or REMA');
    end
end

if arctic_or_antarctic == 1
    load('ArcticDEM_Tile_Index_Rel7.mat')
else
    load('REMA_Tile_Index_Rel1.mat')
end
    
%%%%%%%%%%%%%%%%%%%%%%% Here we find the box bounds
for i = 1:length(rdata)
    x1(i) = rdata(i).X(1);
    x2(i) = rdata(i).X(2);
    y1(i) = rdata(i).Y(3);
    y2(i) = rdata(i).Y(1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG PLOT IF THINGS AREN'T
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WORKING THE WAY YOU EXPECT
debug_flag = 0;
if debug_flag == 1;
    figure(1)
    hold off
    for i = 1:length(x1);
        plot_box = box_from_corners([x1(i) x2(i)],[y1(i) y2(i)]);
        plot(plot_box(:,1),plot_box(:,2),'Color','black')
        hold all
    end
    plot(input_data(:,1),input_data(:,2),'o','Color','blue')
end

%%%%%%%%%%%%%%%%%%%%%% Here we find which box each input point falls within
opts = [];
for i = 1:length(input_data(:,1))
    ind = find(input_data(i,1) <= x2 & input_data(i,1) > x1 & input_data(i,2) <= y2 & input_data(i,2) > y1);
    if length(ind) > 0
        opts = [opts; ind];
    else
    end
end

opts = remove_duplicates(opts);

%%%%%%%%%%%%%%%%%%%% Here we collect the information for those tiles
for i = 1:length(opts)
    tile_info(i).name = rdata(opts(i)).name;
    tile_info(i).tile = rdata(opts(i)).tile;
    tile_info(i).fileurl = rdata(opts(i)).fileurl;
    tile_info(i).bbox = box_from_corners(rdata(opts(i)).BoundingBox(1,1),rdata(opts(i)).BoundingBox(2,1),rdata(opts(i)).BoundingBox(1,2),rdata(opts(i)).BoundingBox(2,2)) ;
end

if exist('tile_info') == 0
    tile_info.name = [];
    tile_info.tile = [];
    tile_info.fileurl = [];
    tile_info.bbox = [];
end


%%%%%%%%%%%%%%%%%%%% If requested, we download the tiles heref
if download_flag == 1
    for i = 1:length(tile_info)
        pgc_tile_download(tile_info(i),download_dir,1);
    end
end



end