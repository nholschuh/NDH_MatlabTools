function picks = Channel_Picker(input_file,save_prefix);
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% This function was designed for an undergraduate project centered around
% picking basal crevasse locations and their sizes. Priyanka Bose was the
% student working on this project (PXB5178).
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
cice_import

if exist('save_prefix') == 0
    save_prefix = 'Channel_PXB_';
end

if str_contain(input_file,'mig') == 1
    %%%% An example name - PickableData_20131226_11_006_mig.mat
    sto_flag = 1;
    pick_file = ['PXB_',input_file(14:end-8),'_PICKS.mat'];
    savename = [save_prefix,input_file(14:end-8),'.mat']
    eval(input_file(end-6:end-4))
else
    %%%% An example name - Data_20131226_11_006.mat
    sto_flag = 0;
    pick_file = ['PXB_',input_file(6:end-4),'_PICKS.mat']
    savename = [save_prefix,input_file(6:end)];
    line_ind = eval(input_file(end-10:end-8));
end

if exist(pick_file) == 2
    
    load(input_file)
    load(pick_file)
    
    if sto_flag == 1
        Latitude = lat;
        Longitude = long;
        Elevation = elev;
        Data = migdata;
        Time = travel_time;
    end

    
    %%%%% Pick pre-processing:
    if length(picks.samp2(:,1)) > 1
        samp_range = max(picks.samp2(:,1)) - min(picks.samp2(:,1));
    else
        samp_range = 0;
    end
    
    if samp_range > 50
        surface_options = find(picks.samp2(:,1) < mean(picks.samp2(:,1)));
        surface_ind = max(surface_options);
        
        bed_options = find(picks.samp2(:,1) > mean(picks.samp2(:,1)));
        bed_ind = max(bed_options);
    end
 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    [x y] = polarstereo_fwd(Latitude,Longitude);

    
    if samp_range < 50
        surface_ind = length(picks.samp2(:,1));
        [bed_elev surf_elev] = pickelevation(geocoords.elev,picks.samp2(surface_ind,:),0,travelcoords.travel_time);
        %plot(1:length(picks.samp2(1,:)),picks.samp2(end,:),'Color','blue')
    else
        [bed_elev surf_elev] = pickelevation(geocoords.elev,picks.samp2(surface_ind,:),picks.samp2(bed_ind,:),travelcoords.travel_time);
        %plot(1:length(picks.samp2(surface_ind,:)),picks.samp2(surface_ind,:),'Color','blue')
        %plot(1:length(picks.samp2(bed_ind,:)),picks.samp2(bed_ind,:),'Color','red')
    end
    
    [depth_data shift_amount depth_axis surface_elev] = depth_shift(Data,Time,picks.samp2(surface_ind,:),Elevation);
    
    imagesc(1:length(depth_data(1,:)),depth_axis,lp(depth_data));
    set(gca,'YDir','normal')
    colormap(gray)
    colorbar
    hold all
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%% Here is the part where we put in the predicted picks
    load transect_picks.mat
    search_inds = find(point_info(:,10) == line_ind);
    for i = 1:length(search_inds);
        prompt_ind = find_nearest_xy([x' y'],point_info(search_inds(i),1:2));
        plot(prompt_ind,0,'o','Color','red');
    end
       
       
    disp('Take a moment to adjust the figure zoom and color, then type ''dbcont'' to continue')
    disp('     Colormap Editing - caxis([ low_value high_value ])')
    disp('')
    keyboard
    disp('Picker Commands')
    disp('  click - select point')
    disp('  q - end selection')
    disp('  u - undo previous selection')   
    
    [crevasse_picks] = graphical_selection(2);
    
    trace_num = crevasse_picks(:,1);
    depth = crevasse_picks(:,2);
    dt = Time(2)-Time(1);
    
    crevasse_height = depth - bed_elev(trace_num);
    crevasse_tip = depth;
    crevasse_lat = Latitude(trace_num)';
    crevasse_lon = Longitude(trace_num)';
    crevasse_x = x(trace_num);
    crevasse_y = y(trace_num);
    
    save(savename,'crevasse_height','crevasse_tip','crevasse_lat','crevasse_lon','crevasse_x','crevasse_y')
    
else
    disp('No pick file associated with this data');
    
end

