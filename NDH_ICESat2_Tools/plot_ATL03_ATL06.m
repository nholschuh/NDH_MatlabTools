function plot_ATL03_ATL06(atl03s,atl06s,bp,l_or_r,additional_groundfinder,truthfile,subsetflag,subset1,subset2)
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% This file reads the atl03 and atl06 h5 files, and plots them on top of
% one another for comparison.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% atl03s - Filename (or cell list of filenames) for the ATL03 photons
% atl06s - Filename (or cell list of filenames) for the ATL06 surface
% bp - [1] The beam pair to plot from (1-3)
% l_or_r - [1] left, (2) right, or (3) both beams plotted
% additional_groundfinder - filename for a groundfinder file
% subset_flag - a flag allowing you to choose from the following:
%     0: Full output, following the .h5 file structure [default]
%     1: data subset by either segment id numbers or fraction of the length
%        of the file
%     2: granule subset by segment id, but only containing a subset of
%        the variables
%     Inf: full length of the granule, but only containing a subset of the
%        variables
% truthfile - set to [0]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%%%%%%%%%%%%%%%%%%%%%%%%%% This flag plots the running median fit to the
%%%%%%%%%%%%%%%%%%%%%%%%%% high confidence photons as well as ATL06
alex_flag = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%% This flag plots ATL06 as fit segments [1] or a
%%%%%%%%%%%%%%%%%%%%%%%%%% line
ben_or_points = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%% This flag includes the photons in the plot [1]
include_phots = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%% This flag includes a map of the coordinates
include_map = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%% xaxis flag
xaxis_flag = 0;
%%%% 0 - x_RGT
%%%% 1 - time
%%%% 2 - relative x_RGT for granule
%%%% 3 - relative time for granule

vert_shift = 0;

if xaxis_flag ~= 0
    ben_or_points = 0;
end

if iscell(atl03s) == 0
    atl03s = {atl03s};
end

if iscell(atl06s) == 0
    atl06s = {atl06s};
end

if exist('bp') == 0
    bp = 1;
end

if exist('l_or_r') == 0
    l_or_r = 1;
end

if exist('subsetflag') == 0
    subsetflag = 0;
    subset1 = 0;
    subset2 = 0;
end

if exist('additional_groundfinder') == 0
    additional_groundfinder = [];
else
    if iscell(additional_groundfinder) == 0
        additional_groundfinder = {additional_groundfinder};
    else
        additional_groundfinder = [];
    end
end

if exist('truthfile') == 0
    truthfile = [];
    truth_search_flag = 0;
elseif truthfile == 0
    truthfile = [];
    truth_search_flag = 0;
else
    if iscell(truthfile) == 0 & length(truthfile) > 1
        truthfile = {truthfile};
        truth_search_flag = 0;
    elseif truthfile == 1
        truth_search_flag = 1;
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% ATL03 Assembly %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



photon_h_l = [];
photon_x_l_seg = [];
photon_segid_l = [];
photon_segx_l = [];
photon_segcount_l = [];
photon_seglength_l = [];
photon_x_l = [];
photon_class_l = [];

photon_h_r = [];
photon_x_r_seg = [];
photon_segid_r = [];
photon_segx_r = [];
photon_segcount_r = [];
photon_seglength_r = [];
photon_x_r = [];
photon_class_r = [];

if length(truthfile) > 0
    truthx_l = [];
    truthh_l = [];
    truthx_r = [];
    truthh_r = [];
end



land_ice_conf_flag = 4;
for j = 1:length(atl03s)
    atl03_fname = atl03s{j};
    atl06_fname = atl06s{j};
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Establishes the first value for plotting
    %%%%%%%%%%%%%%%%%%%%%%%%%%% relative distance and time
    if exist('shifter') == 0
        if xaxis_flag > 1;
            td03 = read_ATL03_h5(atl03_fname,subsetflag,0,0.01);
            td06 = read_ATL06_h5(atl06_fname,subsetflag,0,0.01);
            if mod(xaxis_flag,2) == 0
                shifter = eval(['td03.gt',num2str(bp),'l.heights.dist_ph_along(1)']);
                shifter6 = 0;
            else
                shifter = eval(['td03.ancillary_data.start_delta_time']);
                shifter6 = eval(['td06.ancillary_data.start_delta_time']);
            end
            clear td03 td06
        end
    end
    
    [atl03 subset1 subset2] = read_ATL03_h5(atl03_fname,subsetflag,subset1,subset2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% This is the code for real ATL03s with full structure
    if isfield(eval(['atl03.gt',num2str(bp),'l']),'geolocation') == 1
        
        photon_h_l = [photon_h_l; eval(['atl03.gt',num2str(bp),'l.heights.h_ph'])];
        photon_segid_l = [photon_segid_l; eval(['atl03.gt',num2str(bp),'l.geolocation.segment_id'])];
        photon_segcount_l = [photon_segcount_l; eval(['atl03.gt',num2str(bp),'l.geolocation.segment_ph_cnt'])];
        photon_seglength_l = [photon_seglength_l; eval(['atl03.gt',num2str(bp),'l.geolocation.segment_length'])];
        
        if mod(xaxis_flag,2) == 0
            photon_x_l_seg = [photon_x_l_seg; eval(['atl03.gt',num2str(bp),'l.heights.dist_ph_along'])];
            photon_segx_l = [photon_segx_l; eval(['atl03.gt',num2str(bp),'l.geolocation.segment_dist_x'])];
            %%%%%%%%%%%% Produce the x_RTC for individual photons from segment
            %%%%%%%%%%%% position and photon position within segment
            running_count_1 = 1;
            for i = 1:length(photon_segcount_l)
                running_count_2 = running_count_1 + photon_segcount_l(i) - 1;
                photon_x_l = [photon_x_l; ones(photon_segcount_l(i),1)*photon_segx_l(i)+photon_x_l_seg(running_count_1:running_count_2)];
                running_count_1 = running_count_2 + 1;
            end
        elseif mod(xaxis_flag,2) == 1
            photon_x_l = [photon_x_l_seg; eval(['atl03.gt',num2str(bp),'l.heights.delta_time'])];
        end

        photon_class_l = [photon_class_l; eval(['atl03.gt',num2str(bp),'l.heights.signal_conf_ph(:,:)'])];
        %row_ind = find(max(max(photon_class_l')) == max(photon_class_l'));
        row_ind = land_ice_conf_flag;
        photon_class_l = photon_class_l(row_ind(1),:);
        
        
        photon_h_r = [photon_h_r; eval(['atl03.gt',num2str(bp),'r.heights.h_ph'])];
        photon_segid_r = [photon_segid_r; eval(['atl03.gt',num2str(bp),'r.geolocation.segment_id'])];
        photon_segcount_r = [photon_segcount_r; eval(['atl03.gt',num2str(bp),'r.geolocation.segment_ph_cnt'])];
        photon_seglength_r = [photon_seglength_r; eval(['atl03.gt',num2str(bp),'r.geolocation.segment_length'])];
        
        if mod(xaxis_flag,2) == 0
            photon_x_r_seg = [photon_x_r_seg; eval(['atl03.gt',num2str(bp),'r.heights.dist_ph_along'])];
            photon_segx_r = [photon_segx_r; eval(['atl03.gt',num2str(bp),'r.geolocation.segment_dist_x'])];
            running_count_1 = 1;
            for i = 1:length(photon_segcount_r)
                running_count_2 = running_count_1 + photon_segcount_r(i) - 1;
                photon_x_r = [photon_x_r; ones(photon_segcount_r(i),1)*photon_segx_r(i)+photon_x_r_seg(running_count_1:running_count_2)];
                running_count_1 = running_count_2 + 1;
            end
        elseif mod(xaxis_flag,2) == 1
            photon_x_r = [photon_x_r_seg; eval(['atl03.gt',num2str(bp),'r.heights.delta_time'])];
        end

        

        photon_class_r = [photon_class_r; eval(['atl03.gt',num2str(bp),'r.heights.signal_conf_ph(:,:)'])];
        %row_ind = find(max(max(photon_class_r')) == max(photon_class_r'));
        row_ind = land_ice_conf_flag;
        photon_class_r = photon_class_r(row_ind(1),:);
    else
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%% This is the code Ben's ATL03s with modified structure
        
        
        if length(additional_groundfinder) > 0
            additional_groundfinder_name = additional_groundfinder{j};
            atl03_gf = read_h5(additional_groundfinder_name);
            
            photon_h_l = [photon_h_l; eval(['atl03_gf.channelgt',num2str(bp),'l.photon.h_ph'])];
            photon_x_l = [photon_x_l; eval(['atl03.gt',num2str(bp),'l.x_RGT(1:length(atl03_gf.channelgt',num2str(bp),'l.photon.h_ph))'])];
            
            photon_h_r = [photon_h_r; eval(['atl03_gf.channelgt',num2str(bp),'r.photon.h_ph'])];
            photon_x_r = [photon_x_r; eval(['atl03.gt',num2str(bp),'r.x_RGT(1:length(atl03_gf.channelgt',num2str(bp),'r.photon.h_ph))'])];
            
            photon_class_l = [photon_class_l; eval(['atl03_gf.channelgt',num2str(bp),'l.photon.ph_class'])];
            photon_class_r = [photon_class_r; eval(['atl03_gf.channelgt',num2str(bp),'r.photon.ph_class'])];
        else
            photon_x_l = [photon_x_l; eval(['atl03.gt',num2str(bp),'l.x_RGT'])];
            photon_h_l = [photon_h_l; eval(['atl03.gt',num2str(bp),'l.h'])];
            
            photon_x_r = [photon_x_r; eval(['atl03.gt',num2str(bp),'r.x_RGT'])];
            photon_h_r = [photon_h_r; eval(['atl03.gt',num2str(bp),'r.h'])];
            
            photon_class_l = [photon_class_l; eval(['atl03.gt',num2str(bp),'l.ph_class'])];
            photon_class_r = [photon_class_r; eval(['atl03.gt',num2str(bp),'r.ph_class'])];
        end
    end
    
end

ri = find(isnan(photon_h_l) == 1 | photon_h_l > 1e5);
ri2 = find(isnan(photon_h_r) == 1 | photon_h_r > 1e5);
photon_x_l(ri) = [];
photon_h_l(ri) = [];
photon_h_l = photon_h_l+vert_shift;
photon_class_l(ri) = [];
photon_x_r(ri2) = [];
photon_h_r(ri2) = [];
photon_h_r = photon_h_r+vert_shift;
photon_class_r(ri2) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% ATL06 Assembly %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% This code is designed to be able to accept multiple atl03
%%%%%%%%%%%%%%%%% and atl06 files, and concatenate them
segs = [];
lat_l = [];
lon_l = [];
lat_r = [];
lon_r = [];
dhfdx_l = [];
x_l = [];
q_l = [];
h_l = [];
x_r = [];
q_r = [];
h_r = [];
dhfdx_r = [];


for j = 1:length(atl06s)
    atl06_fname = atl06s{j};
    
    if atl06s{j}(end-2:end) == 'mat'
        load(atl06s{j});
        
        segs = [segs; D3(bp).seg_count(:,1)];
        x_l = [x_l; D3(bp).x_RGT(:,1)];
        q_l = [q_l; D3(bp).ATL06_quality_summary(:,1)];
        h_l = [h_l; D3(bp).h_LI(:,1)];
        lat_l = [lat_l; D3(bp).lat_ctr(:,1)];
        lon_l = [lon_l; D3(bp).lon_ctr(:,1)];
        dhfdx_l = [dhfdx_l; D3(bp).dh_fit_dx(:,1)];
        %%%%%%%%%% Load in the right beam
        x_r = [x_r; D3(bp).x_RGT(:,2)];
        q_r = [q_r; D3(bp).ATL06_quality_summary(:,2)];
        h_r = [h_r; D3(bp).h_LI(:,2)];
        lat_r = [lat_r; D3(bp).lat_ctr(:,2)];
        lon_r = [lon_r; D3(bp).lon_ctr(:,2)];
        dhfdx_r = [dhfdx_r; D3(bp).dh_fit_dx(:,2)];
        
    else
        
        atl06 = read_ATL06_h5(atl06_fname,subsetflag,subset1,subset2);
        
        segs = [segs; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.segment_id'])];
        if mod(xaxis_flag,2) == 0
            x_l = [x_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.ground_track.x_atc'])];
        elseif mod(xaxis_flag,2) == 1
            x_l = [x_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.delta_time'])];
        end
        q_l = [q_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.atl06_quality_summary'])];
        h_l = [h_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.h_li'])];
        lat_l = [lat_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.latitude'])];
        lon_l = [lon_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.longitude'])];
        dhfdx_l = [dhfdx_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.fit_statistics.dh_fit_dx'])];
        %%%%%%%%%% Load in the right beam
        if mod(xaxis_flag,2) == 0
            x_r = [x_r; eval(['atl06.gt',num2str(bp),'r.land_ice_segments.ground_track.x_atc'])];
        elseif mod(xaxis_flag,2) == 1
            x_r = [x_r; eval(['atl06.gt',num2str(bp),'r.land_ice_segments.delta_time'])];
        end
        q_r = [q_r; eval(['atl06.gt',num2str(bp),'r.land_ice_segments.atl06_quality_summary'])];
        h_r = [h_r; eval(['atl06.gt',num2str(bp),'r.land_ice_segments.h_li'])];
        lat_r = [lat_r; eval(['atl06.gt',num2str(bp),'r.land_ice_segments.latitude'])];
        lon_r = [lon_r; eval(['atl06.gt',num2str(bp),'r.land_ice_segments.longitude'])];
        dhfdx_r = [dhfdx_r; eval(['atl06.gt',num2str(bp),'r.land_ice_segments.fit_statistics.dh_fit_dx'])];
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% Here we do the groundtruthing
    if length(truthfile) > 0 && truth_search_flag == 0
        load(truthfile{j});
        
        truthx_l = [truthx_l; double(eval(['outdata2.gt',num2str(bp),'l.recorded_x_RGT']))];
        truthh_l = [truthh_l; eval(['outdata2.gt',num2str(bp),'l.true_h'])];
        truthx_r = [truthx_r; double(eval(['outdata2.gt',num2str(bp),'r.recorded_x_RGT']))];
        truthh_r = [truthh_r; eval(['outdata2.gt',num2str(bp),'r.true_h'])];
        
    elseif length(truthfile) > 0 && truth_search_flag == 1
        [xtemp ytemp] = polarstereo_fwd(lat_l,lon_l);
        truthx_l = x_l;
        if min(lat_l) < 0
            truthh_l = Antarctic_Topography_search([xtemp ytemp],5);
        else
            truthh_l = Greenland_Topography_search([xtemp ytemp],8);
        end
        [xtemp ytemp] = polarstereo_fwd(lat_r,lon_r);
        truthx_r = x_r;
        if min(lat_r) < 0
            %%%%%%% Helm DEM
            %truthh_r = Antarctic_Topography_search([xtemp ytemp],5);
            %%%%%%% REMA
            truthh_r = Antarctic_Topography_search([xtemp ytemp],11);
        else
            truthh_r = Greenland_Topography_search([xtemp ytemp],8);
        end
    end
    
end

ind1 = find(h_l < 1e5);
ind2 = find(h_r < 1e5);
q_l = q_l(ind1);
x_l = x_l(ind1);
h_l = h_l(ind1)+vert_shift;
q_r = q_r(ind2);
x_r = x_r(ind2);
h_r = h_r(ind2)+vert_shift;
dhfdx_l = dhfdx_l(ind1);
dhfdx_r = dhfdx_r(ind2);


%h_l(find(q_l == 1)) = NaN;
%h_r(find(q_r == 1)) = NaN;


%%%%%%%%% Sets the xaxis to relative values within a granule
if xaxis_flag > 1;
    x_l = x_l - shifter;
    x_r = x_r - shifter;
    photon_x_l = photon_x_l - shifter;
    photon_x_r = photon_x_r - shifter;
    if length(truthfile) > 0
        truthx_l = truthx_l - shifter;
        truthx_r = truthx_r - shifter;
    end
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here, the full plot is created, and
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% subsequently panned across. There are two
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% complete sections here, one for the strong
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% beam and one for the weak beam.


c = {'lightgray','darkgray','slateblue','lightblue'};
animation_flag = 0;

if l_or_r == 1 | l_or_r == 3
    
    
    if l_or_r == 3
        aa = subplot(2,1,1);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mainly for testing, allows
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% a DC shift of the x
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% positions
    %     left_shift = min(photon_x_l);
    %     %left_shift = 0;
    %     photon_x_l = photon_x_l-left_shift;
    %     x_l = x_l - left_shift;
    
    hold off
    for i = 1:4
        if i == 1
            inds = [find(photon_class_l <= i)];
        else
            inds = [find(photon_class_l == i)];
        end
        if include_phots == 1
            if length(inds) > 0
                plot(photon_x_l(inds),photon_h_l(inds),'.','Color',color_call(c{i}),'MarkerSize',(i+2)*1.5)
            end
        end
        hold all
    end
    
    if alex_flag == 1
        median_inds = find(photon_class_l >= 3);
        run_photon_x_l = photon_x_l(median_inds);
        run_photon_h_l = photon_h_l(median_inds);
        
        run_filt_photon_h_l = smooth_ndh(run_photon_h_l,50,3);
        plot(run_photon_x_l,run_filt_photon_h_l,'Color',color_call('red'),'LineWidth',2)
    end
    
    if length(truthfile) > 0
        plot(truthx_l,truthh_l,'o','Color','black','MarkerFaceColor','white','MarkerSize',4)
    end
    
    if ben_or_points == 1
        %plot_segs(x_l,h_l,dhfdx_l,40,['''Color'',color_call(''darkblue''),''LineWidth'',2']);
        %plot_segs(x_l,h_l,dhfdx_l,40,['''Color'',color_call(''gold''),''LineWidth'',2']);
        plot_segs(x_l,h_l,dhfdx_l,40,['''Color'',color_call(''black''),''LineWidth'',2']);
    else
        plot(x_l,h_l,'Color',color_call('black'),'LineWidth',2);
    end
    
    legend_inp = {};
    if include_phots == 1
        for i = 1:4
            if i == 1
                legend_inp{i} = ['Photon Type - ',num2str(i-1),'/',num2str(i)];
            else
                legend_inp{i} = ['Photon Type - ',num2str(i)];
            end
        end
    end
    
    if alex_flag == 1
        if length(truthfile) > 0
            legend_inp(end+1:end+3) = {'ATL03 Height','''''Ground Truth''''','ATL06'};
        else
            legend_inp(end+1:end+2) = {'ATL03 Height','ATL06'};
        end
    else
        if length(truthfile) > 0
            legend_inp(end+1:end+2) = {'''''Ground Truth''''','ATL06'};
        else
            legend_inp(end+1) = {'ATL06'};
        end
    end
    
    
    legend(legend_inp)
    if xaxis_flag == 0
        xlabel('Distance Along Track (m)')
    else
       xlabel('Relative Delta Time (s)') 
    end
    ylabel('Left Beam - Elevation')
    set(gcf,'Color','white')
    maximize
    
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %%%%%%%%%% Panning Animation
    %     %%%%%%%%%% (Right now this is not set up to be portable)
    %
    %     if animation_flag == 1
    %         %%%%%%%%%%%%%%%%%%%%% This defines the path for the camera to take
    %         xwind = 1000;
    %         ywind = 50;
    %         inds = find(photon_class_l == 2);
    %         subinds = find(diff(photon_x_l(inds)) ~= 0);
    %         inds = inds(subinds+1);
    %
    %         if length(inds) == 0
    %             inds = find(photon_class_l == 0);
    %             subinds = find(diff(photon_x_l(inds)) ~= 0);
    %             inds = inds(subinds+1);
    %         end
    %
    %         xp = linspace(min(photon_x_l)+xwind,max(photon_x_l)-xwind,5000);
    %         path = smooth_ndh(photon_h_l(inds),2000);
    %         path = interp1(photon_x_l(inds),path,xp,'linear','extrap');
    %     end
    
end

if l_or_r == 2 | l_or_r == 3
    
    if l_or_r == 3
        bb = subplot(2,1,2);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mainly for testing, allows
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% a DC shift of the x
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% positions
    %     if exist('left_shift') == 0
    %         left_shift = min(photon_x_r);
    %         left_shift = 0;
    %     end
    %     photon_x_r = photon_x_r-left_shift;
    %     x_r = x_r - left_shift;
    
    hold off
    for i = 1:4
        if i == 1
            inds = [find(photon_class_r <= i)];
        else
            inds = [find(photon_class_r == i)];
        end
        if include_phots == 1
            if length(inds) > 0
                plot(photon_x_r(inds),photon_h_r(inds),'.','Color',color_call(c{i}),'MarkerSize',(i+2)*1.5)
            end
        end
        hold all
    end
    
    if alex_flag == 1
        median_inds = find(photon_class_r >= 3);
        run_photon_x_r = photon_x_r(median_inds);
        run_photon_h_r = photon_h_r(median_inds);
        
        run_filt_photon_h_r = smooth_ndh(run_photon_h_r,50,3);
        plot(run_photon_x_r,run_filt_photon_h_r,'Color',color_call('red'),'LineWidth',2)
    end
    
    if length(truthfile) > 0
        plot(truthx_r,truthh_r,'o','Color','black','MarkerFaceColor','white','MarkerSize',4)
    end
    
    if ben_or_points == 1
        %plot_segs(x_r,h_r,dhfdx_r,40,['''Color'',color_call(''darkblue''),''LineWidth'',2']);
        %plot_segs(x_r,h_r,dhfdx_r,40,['''Color'',color_call(''gold''),''LineWidth'',2']);
        plot_segs(x_r,h_r,dhfdx_r,40,['''Color'',color_call(''black''),''LineWidth'',2']);
    else
        plot(x_r,h_r,'Color',color_call('black'),'LineWidth',2);
    end
    
    legend_inp = {};
    if include_phots == 1
        for i = 1:4
            if i == 1
                legend_inp{i} = ['Photon Type - ',num2str(i-1),'/',num2str(i)];
            else
                legend_inp{i} = ['Photon Type - ',num2str(i)];
            end
        end
    end
    
    
    if alex_flag == 1
        if length(truthfile) > 0
            legend_inp(end+1:end+3) = {'ATL03 Height','''''Ground Truth''''','ATL06'};
        else
            legend_inp(end+1:end+2) = {'ATL03 Height','ATL06'};
        end
    else
        if length(truthfile) > 0
            legend_inp(end+1:end+2) = {'''''Ground Truth''''','ATL06'};
        else
            legend_inp(end+1) = {'ATL06'};
        end
    end
    
    legend(legend_inp)
    
    legend({['Beam ',num2str(bp),' - Right']},'Location','northwest')
    
    if xaxis_flag == 0
        xlabel('Distance Along Track (m)')
    else
       xlabel('Relative Delta Time (s)') 
    end
    
    ylabel('Right Beam - Elevation')
    
    
    set(gcf,'Color','white')
    
    
    %%
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %%%%%%%%%% Panning Animation
    %     %%%%%%%%%% (Right now this is not set up to be portable)
    %     if animation_flag == 1
    %         xwind = 1000;
    %         ywind = 50;
    %         inds = find(photon_class_r == 2);
    %         subinds = find(diff(photon_x_r(inds)) ~= 0);
    %         inds = inds(subinds+1);
    %
    %         if length(inds) == 0
    %             inds = find(photon_class_r == 0);
    %             subinds = find(diff(photon_x_r(inds)) ~= 0);
    %             inds = inds(subinds+1);
    %         end
    %
    %
    %         xp = linspace(min(photon_x_r)+xwind,max(photon_x_r)-xwind,5000);
    %         path = smooth_ndh(photon_h_r(inds),2000);
    %         path = interp1(photon_x_r(inds),path,xp,'linear','extrap');
    %     end
    
    
end


if l_or_r == 3
    linkaxes([aa bb],'xy');
    subplot(2,1,1)
end

if l_or_r == 1
    title([true_name(atl03_fname),' -- Beam ',num2str(bp),' - Left']);
elseif l_or_r == 2
    title([true_name(atl03_fname),' -- Beam ',num2str(bp),' - Right']);
elseif l_or_r == 3
    title([true_name(atl03_fname),' -- Beam ',num2str(bp),' - Left/Right']);
end

if include_map == 1
    figure()
    if min(lat_r) < 0
        [xtemp ytemp] = polarstereo_fwd(lat_r,lon_r);
        groundingline(1);
        plot(xtemp,ytemp,'Color','blue')
        axis equal
    else
        [xtemp ytemp] = polarstereo_fwd(lat_r,lon_r);
        groundingline(6);
        groundingline(7);
        plot(xtemp,ytemp,'Color','blue')
        axis equal
    end
    
    title(true_name(atl03_fname));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Code for Animation
%     loop_steps = 1:length(xp);
%     for i = loop_steps
%
%         xlim([xp(i)-xwind xp(i)+xwind])
%         ylim([path(i)-ywind path(i)+ywind]);
%         generate_frames(['SignalFinder_t',num2str(repeatnum),'_',btype,'_Section',num2str(jj)],['SignalFinder_t',num2str(repeatnum),'_',btype,'_Section',num2str(jj)],i-loop_steps(1)+1)
%     end
%








