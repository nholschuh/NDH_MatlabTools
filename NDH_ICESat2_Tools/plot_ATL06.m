function plot_ATL06(atl06s,bp,l_or_r,truthfile,subsetflag,subset1,subset2)
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
% truthfile - 0: no ground truth, 1: HELM ground truth, 2: HELM + REMA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

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

if exist('truthfile') == 0
    truthfile = [];
    truthh_l = [];
    truthh_r = [];
    truth_search_flag = 0;
elseif truthfile == 0
    truthfile = [];
    truthh_l = [];
    truthh_r = [];
    truth_search_flag = 0;
else
    if iscell(truthfile) == 0 & length(truthfile) > 1
        truthfile = {truthfile};
        truth_search_flag = 0;
    elseif truthfile == 1
       truth_search_flag = 1; 
    elseif truthfile == 2
        truth_search_flag = 2;
    end
end


if length(truthfile) > 0
    truthx_l = [];
    truthh_l = [];
    truthx_r = [];
    truthh_r = [];
    truthh_l2 = [];
    truthh_r2 = [];    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% ATL06 Assembly %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% This code is designed to be able to accept multiple atl03
%%%%%%%%%%%%%%%%% and atl06 files, and concatenate them
segs_l = [];
lat_l = [];
lon_l = [];
lat_r = [];
lon_r = [];
dhfdx_l = [];
segs_r = [];
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
        
        segs_l = [segs_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.segment_id'])];
        x_l = [x_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.ground_track.x_atc'])];
        q_l = [q_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.atl06_quality_summary'])];
        h_l = [h_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.h_li'])];
        lat_l = [lat_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.latitude'])];
        lon_l = [lon_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.longitude'])];
        dhfdx_l = [dhfdx_l; eval(['atl06.gt',num2str(bp),'l.land_ice_segments.fit_statistics.dh_fit_dx'])];
        %%%%%%%%%% Load in the right beam
        segs_r = [segs_r; eval(['atl06.gt',num2str(bp),'r.land_ice_segments.segment_id'])];
        x_r = [x_r; eval(['atl06.gt',num2str(bp),'r.land_ice_segments.ground_track.x_atc'])];
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
       
    elseif length(truthfile) > 0 && truth_search_flag > 1
       [xtemp ytemp] = polarstereo_fwd(lat_l,lon_l);
       truthx_l = x_l;
       if min(lat_l) < 0
           truthh_l = Antarctic_Topography_search([xtemp ytemp],5);
           if truth_search_flag == 2
               truthh_l2 = Antarctic_Topography_search([xtemp ytemp],11);
           end
       else
           truthh_l = Greenland_Topography_search([xtemp ytemp],2);
           if truth_search_flag == 2
               truthh_l2 = Greenland_Topography_search([xtemp ytemp],8);
           end
       end
       [xtemp ytemp] = polarstereo_fwd(lat_r,lon_r);
       truthx_r = x_r;
       if min(lat_r) < 0
           truthh_r = Antarctic_Topography_search([xtemp ytemp],5);
           if truth_search_flag == 2
               truthh_r2 = Antarctic_Topography_search([xtemp ytemp],11);
           end
       else
           truthh_r = Greenland_Topography_search([xtemp ytemp],8);
           if truth_search_flag == 2
               truthh_r2 = Greenland_Topography_search([xtemp ytemp],8);
           end
       end
    end
    
end

ind1 = find(h_l < 1e5);
ind2 = find(h_r < 1e5);
x_l = x_l(ind1);
h_l = h_l(ind1);
x_r = x_r(ind2);
h_r = h_r(ind2);
segs_l = segs_l(ind1);
segs_r = segs_r(ind2);
dhfdx_l = dhfdx_l(ind1);
dhfdx_r = dhfdx_r(ind2);
    
h2_l = h_l;
h2_l(find(q_l == 1)) = NaN;
h2_r = h_r;
h2_r(find(q_r == 1)) = NaN;




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here, the full plot is created, and
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% subsequently panned across. There are two
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% complete sections here, one for the strong
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% beam and one for the weak beam.


c = {'lightgray','darkgray','lightblue','slateblue','blue'};
animation_flag = 0;

    seg_or_xrgt = 1;
    %% 0 - segments
    %% 1 - xrgt

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
   

    
    if length(truthh_l) > 0 & length(truthh_l2) == 0
        if seg_or_xrgt == 0
            plot(truthx_l,truthh_l,'.','Color','black','MarkerFaceColor','white','MarkerSize',4)
        else
            plot(segs_l,truthh_l,'.','Color','black','MarkerFaceColor','white','MarkerSize',4)
        end
        hold all
    elseif length(truthh_l) > 0 & length(truthh_l2) > 0
        if seg_or_xrgt == 0
            plot(segs_l,truthh_l,'.','Color','black','MarkerFaceColor','white','MarkerSize',4)
            hold all
            plot(segs_l,truthh_l2,'.','Color',[0.5 0.5 0.5],'MarkerFaceColor','white','MarkerSize',4)
        else
            plot(truthx_l,truthh_l,'.','Color','black','MarkerFaceColor','white','MarkerSize',4)
            hold all
            plot(truthx_l,truthh_l2,'.','Color',[0.5 0.5 0.5],'MarkerFaceColor','white','MarkerSize',4)
        end
    end
    
    if length(x_l) > 20000
        if seg_or_xrgt == 0
            plot(segs_l,h_l,'.','Color',color_call('darkblue'));
        else
            plot(x_l,h_l,'.','Color',color_call('darkblue'));
        end
    else
        if seg_or_xrgt == 0
            plot_segs(segs_l,h_l,dhfdx_l/20,2,['''Color'',color_call(''darkblue''),''LineWidth'',2']);
        else
            plot_segs(x_l,h_l,dhfdx_l,40,['''Color'',color_call(''darkblue''),''LineWidth'',2']);
        end
        hold all
    end
    
    
    if length(truthfile) > 0 & truth_search_flag ~= 2
        legend_inp = {'Ground Truth','ATL06'};
    elseif length(truthfile) > 0 & truth_search_flag == 2
        legend_inp = {'HELM','REMA','ATL06'};
    else
        legend_inp = {'ATL06'};
    end
    
    
    legend(legend_inp)
    if seg_or_xrgt == 0
        xlabel('Segment ID (#)')
    else
        xlabel('x RGT (m)')
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

    if length(truthh_r) > 0 & length(truthh_r2) == 0
        if seg_or_xrgt == 0
            plot(truthx_r,truthh_r,'.','Color','black','MarkerFaceColor','white','MarkerSize',4)
        else
            plot(segs_r,truthh_r,'.','Color','black','MarkerFaceColor','white','MarkerSize',4)
        end
        hold all
    elseif length(truthh_r) > 0 & length(truthh_r2) > 0
        if seg_or_xrgt == 0
            plot(segs_r,truthh_r,'.','Color','black','MarkerFaceColor','white','MarkerSize',4)
            hold all
            plot(segs_r,truthh_r2,'.','Color',[0.5 0.5 0.5],'MarkerFaceColor','white','MarkerSize',4)
        else
            plot(truthx_r,truthh_r,'.','Color','black','MarkerFaceColor','white','MarkerSize',4)
            hold all
            plot(truthx_r,truthh_r2,'.','Color',[0.5 0.5 0.5],'MarkerFaceColor','white','MarkerSize',4)
        end
    end
    
    if length(x_r) > 20000
        if seg_or_xrgt == 0
            plot(segs_r,h_r,'.','Color',color_call('darkblue'));
        else
            plot(x_r,h_r,'.','Color',color_call('darkblue'));
        end
    else
        if seg_or_xrgt == 0
            plot_segs(segs_r,h_r,dhfdx_r/20,2,['''Color'',color_call(''darkblue''),''LineWidth'',2']);
        else
            plot_segs(x_r,h_r,dhfdx_r,40,['''Color'',color_call(''darkblue''),''LineWidth'',2']);
        end
        hold all
    end
   

    
    if length(truthfile) > 0 & truth_search_flag ~= 2
        legend_inp = {'Ground Truth','ATL06'};
    elseif length(truthfile) > 0 & truth_search_flag == 2
        legend_inp = {'HELM','REMA','ATL06'};
    else
        legend_inp = {'ATL06'};
    end
    
    legend(legend_inp)
    if seg_or_xrgt == 0
        xlabel('Segment ID (#)')
    else
        xlabel('x RGT (m)')
    end
    ylabel('Right Beam - Elevation')
    

    set(gcf,'Color','white')
    maximize
   
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


title(true_name(atl06_fname));


figure()
if min(lat_r) < 0
    [xtemp ytemp] = polarstereo_fwd(lat_r,lon_r,0);
    groundingline(1);
    plot(xtemp,ytemp,'Color','blue')
    axis equal
else
    [xtemp ytemp] = polarstereo_fwd(lat_r,lon_r,2);
    groundingline(6); 
    groundingline(7);
    plot(xtemp,ytemp,'Color','blue')
    axis equal
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








