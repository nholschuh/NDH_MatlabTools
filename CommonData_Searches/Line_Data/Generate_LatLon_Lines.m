%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate_LatLon_Lines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

generate_antarctic = 1;
generate_greenland = 0;
high_res = 0;

if high_res == 0
    dlat = 1;
    dlon = 1;
    savename = ['LatLon_xy'];
else
    dlat = 0.001;
    dlon = 0.01;
    savename = ['LatLon_xy_highres'];
end


if generate_antarctic == 1
    Antarctic_Topography(1,'a');
    hold all
    
    %%%%%%%%%%%%%% Define the longitudinal spokes
    lat_range = [-90:dlat:-60];
    lon_opts = -180:0.1:180;
    %%%%%%%%%%%%%% Define the latitudinal rings
    lon_range = -180:dlon:180;
    lat_opts = -90:0.1:-60;
    
    for i = 1:length(lon_opts);
        [lon_linesx{i} lon_linesy{i}] = polarstereo_fwd(lat_range,repmat(lon_opts(i),1,length(lat_range)));
        plot(lon_linesx{i},lon_linesy{i},'Color','black')
        disp(['Completed Longitude ',num2str(i),' of ',num2str(length(lon_opts))])
    end
    
    for i = 1:length(lat_opts);
        [lat_linesx{i} lat_linesy{i}] = polarstereo_fwd(repmat(lat_opts(i),1,length(lon_range)),lon_range);
        plot(lat_linesx{i},lat_linesy{i},'Color','black')
        disp(['Completed Latitude ',num2str(i),' of ',num2str(length(lat_opts))])
    end
    
    save([savename,'_Antarctica.mat'],'lat_linesx','lat_linesy','lon_linesx','lon_linesy','lat_opts','lon_opts')
end

clearvars -except generate_greenland savename dlat dlon

if generate_greenland == 1
    Greenland_Topography(1,'a');
    hold all
    %%%%%%%%%%%%%% Define the longitudinal spokes
    lat_range = [45:dlat:90];
    lon_opts = -75:0.1:-10;
    %%%%%%%%%%%%%% Define the latitudinal rings
    lon_range = -70:dlon:-15;
    lat_opts = 45:0.1:90;
    
    for i = 1:length(lon_opts);
        [lon_linesx{i} lon_linesy{i}] = polarstereo_fwd(lat_range,repmat(lon_opts(i),1,length(lat_range)));
        plot(lon_linesx{i},lon_linesy{i},'Color','black')
        disp(['Completed Longitude ',num2str(i),' of ',num2str(length(lon_opts))])
    end
    
    for i = 1:length(lat_opts);
        [lat_linesx{i} lat_linesy{i}] = polarstereo_fwd(repmat(lat_opts(i),1,length(lon_range)),lon_range);
        plot(lat_linesx{i},lat_linesy{i},'Color','black')
        disp(['Completed Latitude ',num2str(i),' of ',num2str(length(lat_opts))])
    end
    
    save([savename,'_Greenland.mat'],'lat_linesx','lat_linesy','lon_linesx','lon_linesy','lat_opts','lon_opts')
end
