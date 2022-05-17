function plot_ATL03(atl03s,bp,l_or_r,additional_groundfinder,subsetflag,subset1,subset2)
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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

if iscell(atl03s) == 0
    atl03s = {atl03s};
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
elseif additional_groundfinder == 0
    additional_groundfinder = [];
else
    if iscell(additional_groundfinder) == 0
        additional_groundfinder = {additional_groundfinder};
    else
       additional_groundfinder = []; 
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

for j = 1:length(atl03s)
    atl03_fname = atl03s{j};
    
    [atl03 subset1 subset2] = read_ATL03_h5(atl03_fname,subsetflag,subset1,subset2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% This is the code for real ATL03s with full structure
    if isfield(eval(['atl03.gt',num2str(bp),'l']),'geolocation') == 1
        photon_h_l = [photon_h_l; eval(['atl03.gt',num2str(bp),'l.heights.h_ph'])];
        photon_x_l_seg = [photon_x_l_seg; eval(['atl03.gt',num2str(bp),'l.heights.dist_ph_along'])];
        photon_segid_l = [photon_segid_l; eval(['atl03.gt',num2str(bp),'l.geolocation.segment_id'])];
        photon_segx_l = [photon_segx_l; eval(['atl03.gt',num2str(bp),'l.geolocation.segment_dist_x'])];
        photon_segcount_l = [photon_segcount_l; eval(['atl03.gt',num2str(bp),'l.geolocation.segment_ph_cnt'])];
        photon_seglength_l = [photon_seglength_l; eval(['atl03.gt',num2str(bp),'l.geolocation.segment_length'])];
        
        %%%%%%%%%%%% Produce the x_RTC for individual photons from segment
        %%%%%%%%%%%% position and photon position within segment
        running_count_1 = 1;
        for i = 1:length(photon_segcount_l)
            running_count_2 = running_count_1 + photon_segcount_l(i) - 1;
            photon_x_l = [photon_x_l; ones(photon_segcount_l(i),1)*photon_segx_l(i)+photon_x_l_seg(running_count_1:running_count_2)];
            running_count_1 = running_count_2 + 1;
        end
        photon_class_l = [photon_class_l; eval(['atl03.gt',num2str(bp),'l.heights.signal_conf_ph(:,:)'])];
        row_ind = find(max(max(photon_class_l')) == max(photon_class_l'));
        photon_class_l = photon_class_l(row_ind(1),:);
        
        
        photon_h_r = [photon_h_r; eval(['atl03.gt',num2str(bp),'r.heights.h_ph'])];
        photon_x_r_seg = [photon_x_r_seg; eval(['atl03.gt',num2str(bp),'r.heights.dist_ph_along'])];
        photon_segid_r = [photon_segid_r; eval(['atl03.gt',num2str(bp),'r.geolocation.segment_id'])];
        photon_segx_r = [photon_segx_r; eval(['atl03.gt',num2str(bp),'r.geolocation.segment_dist_x'])];
        photon_segcount_r = [photon_segcount_r; eval(['atl03.gt',num2str(bp),'r.geolocation.segment_ph_cnt'])];
        photon_seglength_r = [photon_seglength_r; eval(['atl03.gt',num2str(bp),'r.geolocation.segment_length'])];
        
        running_count_1 = 1;
        for i = 1:length(photon_segcount_l)
            running_count_2 = running_count_1 + photon_segcount_r(i) - 1;
            photon_x_r = [photon_x_r; ones(photon_segcount_r(i),1)*photon_segx_r(i)+photon_x_r_seg(running_count_1:running_count_2)];
            running_count_1 = running_count_2 + 1;
        end
        photon_class_r = [photon_class_r; eval(['atl03.gt',num2str(bp),'r.heights.signal_conf_ph(:,:)'])];
        row_ind = find(max(max(photon_class_r')) == max(photon_class_r'));
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
photon_class_l(ri) = [];
photon_x_r(ri2) = [];
photon_h_r(ri2) = [];
photon_class_r(ri2) = [];




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here, the full plot is created, and
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% subsequently panned across. There are two
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% complete sections here, one for the strong
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% beam and one for the weak beam.






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                     %
%  HACK CHANGING X AXIS TO PERCENT
%                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% photon_x_l = linspace(0,1,length(photon_x_l));




c = {'lightgray','darkgray','lightblue','slateblue','blue'};
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
        if i < 4
            inds = [find(photon_class_l == i-1)];
        else
           inds = [find(photon_class_l >= i-1)]; 
        end
        if length(inds) > 0
            plot(photon_x_l(inds),photon_h_l(inds),'.','Color',color_call(c{i}),'MarkerSize',(i+2)*1.5)
        end
        hold all
    end
    
   
    legend_inp = {};
    for i = 1:4
        legend_inp{i} = ['Photon Type - ',num2str(i-1)];
    end
    
    legend(legend_inp)
    xlabel('Distance Along Track (m)')
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
        if i < 4
            inds = [find(photon_class_r == i-1)];
        else
           inds = [find(photon_class_r >= i-1)]; 
        end
        if length(inds) > 0
            plot(photon_x_r(inds),photon_h_r(inds),'.','Color',color_call(c{i}),'MarkerSize',(i+2)*1.5)
        end
        hold all
    end

  
    legend_inp = {};
    for i = 1:4
        legend_inp{i} = ['Photon Type - ',num2str(i-1)];
    end
    

    legend(legend_inp)
    xlabel('Distance Along Track (m)')
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


title(true_name(atl03_fname));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Code for Animation
%     loop_steps = 1:length(xp);
%     for i = loop_steps
%         
%         xlim([xp(i)-xwind xp(i)+xwind])
%         ylim([path(i)-ywind path(i)+ywind]);
%         generate_frames(['SignalFinder_t',num2str(repeatnum),'_',btype,'_Section',num2str(jj)],['SignalFinder_t',num2str(repeatnum),'_',btype,'_Section',num2str(jj)],i-loop_steps(1)+1)
%     end
% 








