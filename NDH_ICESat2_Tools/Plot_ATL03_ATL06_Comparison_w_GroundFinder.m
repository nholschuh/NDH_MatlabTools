%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot_ATL03_ATL06_Comparison
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

repeatnum = 05;
tracknum = 0780;
l_or_r = 1;


load_opts = [1]; %%%%%%%%%%%%%% This was determined from a manual data inspection

%%%%%%%%%%%%%%%%%%%%%%%%% Identify files for ATL03, Groundfinder Results, and ATL06
%%%%%%%%%%%%%%%%%%%%%%%%% from Ben's groundfinder directory
%tr_dir = ['TrackData_',sprintf('%0.2d',repeatnum),'/'];
tr_dir = [];

load ./Crevasse_Analysis/Crevasse_DEM_7224.mat

%a3_dir = './ATL_Groundfinder/';
%pr_dir = 'Pair_1/';
a3_dir = './Manuscript_PlotFiles/atl03/';
pr_dir = [];

atl03_f = dir([a3_dir,tr_dir,pr_dir,'Track_',sprintf('%0.4d',tracknum),'*.h5']);
for i = 1:length(atl03_f);
    fnl(i) = length(atl03_f(i).name);
end
%save_inds = find(fnl < mean(fnl));
%atl03_f = atl03_f(save_inds);

%a3g_dir = './ATL_Groundfinder/';
a3g_dir = './Manuscript_PlotFiles/atl03_signalselection/';

atl03g_f = dir([a3g_dir,tr_dir,pr_dir,'Track_',sprintf('%0.4d',tracknum),'*.h5']);
for i = 1:length(atl03g_f);
    fnl(i) = length(atl03g_f(i).name);
end
%save_inds = find(fnl > mean(fnl));
%atl03g_f = atl03g_f(save_inds);

%a6_dir = './ATL_Groundfinder/';
a6_dir = './Manuscript_PlotFiles/atl06/';

mat_or_h5 = 1;
if mat_or_h5 == 0
    atl06_f = dir([a6_dir,tr_dir,pr_dir,'Track_',sprintf('%0.4d',tracknum),'*.mat']);
else
    atl06_f = dir([a6_dir,tr_dir,pr_dir,'Track_',sprintf('%0.4d',tracknum),'*.h5']);
end

%%%%%%%%%%%%%%%%%%%%%%%%% Identify the segments in each ATL03 file, and
%%%%%%%%%%%%%%%%%%%%%%%%% load the ATL03 Products
for i = 1:length(atl03_f);
    inds(i,:) = [eval(atl03_f(i).name(end-19:end-12)) eval(atl03_f(i).name(end-10:end-3))];
end

for i = 1:length(load_opts)
    atl03(i) = read_ATL06_h5([a3_dir,tr_dir,pr_dir,atl03_f(load_opts(i)).name]);
    atl03_ss(i) = read_ATL06_h5([a3g_dir,tr_dir,pr_dir,atl03g_f(load_opts(i)).name]);
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%% Read in the ATL06 and plot as a function of
%%%%%%%%%%%%%%%%%%%%%%%%% segment_id

bp = 1;

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

for i = 1:length(load_opts)
    if mat_or_h5 == 1
        data = read_h5([a6_dir,tr_dir,pr_dir,atl06_f(load_opts(i)).name]);
        keyboard
    else
        load([a6_dir,tr_dir,pr_dir,atl06_f(load_opts(i)).name]);
    end
    
    segs = [segs; D3.seg_count(:,1)];
    x_l = [x_l; D3.x_RGT(:,1)];
    
    qs = uint8(~(D3.h_robust_spread(:,1)<1 &...
            D3.signal_selection_source(:,1) <=1 & ...
            D3.h_LI_sigma(:,1) < 1 & ...
            D3.SNR_significance(:,1) < 0.02));
    
    q_l = [q_l; qs];
    h_l = [h_l; D3.h_LI(:,1)];
    lat_l = [lat_l; D3.lat_ctr(:,1)];
    lon_l = [lon_l; D3.lon_ctr(:,1)];
    dhfdx_l = [dhfdx_l; D3.dh_fit_dx(:,1)];
    %%%%%%%%%% Load in the right beam
    x_r = [x_r; D3.x_RGT(:,2)];
    
    qs = uint8(~(D3.h_robust_spread(:,2)<1 &...
        D3.signal_selection_source(:,2) <=1 & ...
        D3.h_LI_sigma(:,2) < 1 & ...
        D3.SNR_significance(:,2) < 0.02));
        
    q_r = [q_r; qs];
    h_r = [h_r; D3.h_LI(:,2)];
    lat_r = [lat_r; D3.lat_ctr(:,2)];
    lon_r = [lon_r; D3.lon_ctr(:,2)];
    dhfdx_r = [dhfdx_r; D3.dh_fit_dx(:,2)];
end
h2_l = h_l;
h2_l(find(q_l == 1)) = NaN;
h2_r = h_r;
h2_r(find(q_r == 1)) = NaN;


%%%%%%%%%%%%%%%%%%%%%% Here we find the true topography for the ATL06 track
%%%%%%%%%%%%%%%%%%%%%% based on the ArcticDEM frame used to compute it. To
%%%%%%%%%%%%%%%%%%%%%% do so, first we have to interpolate the atl06 track
%%%%%%%%%%%%%%%%%%%%%% to a finer resolution, and remove the NaN entries.
x_l = full(x_l);
x_r = full(x_r);

interpaxis_l = 1:length(lat_l);
remove_ind_l = find(isnan(lat_l));
lat_l(remove_ind_l) = [];
lon_l(remove_ind_l) = [];
x_l_interp = x_l;
x_l_interp(remove_ind_l) = [];
interpaxis_l(remove_ind_l) = [];

interpaxis_r = 1:length(lat_r);
remove_ind_r = find(isnan(lat_r));
lat_r(remove_ind_r) = [];
lon_r(remove_ind_r) = [];
x_r_interp = x_r;
x_r_interp(remove_ind_r) = [];
interpaxis_r(remove_ind_r) = [];

lat_l = interp1(interpaxis_l,lat_l,(1:0.1:max(interpaxis_l)));
lon_l = interp1(interpaxis_l,lon_l,(1:0.1:max(interpaxis_l)));
lat_r = interp1(interpaxis_r,lat_r,(1:0.1:max(interpaxis_r)));
lon_r = interp1(interpaxis_r,lon_r,(1:0.1:max(interpaxis_r)));

true_x_l = interp1(interpaxis_l,x_l_interp,(1:0.1:max(interpaxis_l)));
true_x_r = interp1(interpaxis_r,x_r_interp,(1:0.1:max(interpaxis_r)));
[x y] = polarstereo_fwd(lat_l,lon_l);
true_h_l = matsearch([x' y'],DEM.x,DEM.y,DEM.z);
[x y] = polarstereo_fwd(lat_r,lon_r);
true_h_r = matsearch([x' y'],DEM.x,DEM.y,DEM.z);
    
    
%%%%%%%%%%%%%%%%%%%% Now we assemble the ATL03 vectors of interest
photon_x_l = [];
photon_h_l = [];
photon_x_r = [];
photon_h_r = [];
photon_class_l = [];
photon_class_r = [];

for i = 1:length(atl03)
    photon_x_l = [photon_x_l; eval(['atl03(i).gt',num2str(bp),'l.x_RGT'])];
    photon_h_l = [photon_h_l; eval(['atl03(i).gt',num2str(bp),'l.h'])];
    photon_x_r = [photon_x_r; eval(['atl03(i).gt',num2str(bp),'r.x_RGT'])];
    photon_h_r = [photon_h_r; eval(['atl03(i).gt',num2str(bp),'r.h'])];  
    photon_class_l = [photon_class_l; eval(['atl03_ss(i).channelgt',num2str(bp),'l.photon.ph_class'])]; 
    photon_class_r = [photon_class_r; eval(['atl03_ss(i).channelgt',num2str(bp),'r.photon.ph_class'])]; 
end
ri = find(isnan(photon_h_l) == 1);
ri2 = find(isnan(photon_h_r) == 1);
photon_x_l(ri) = [];
photon_h_l(ri) = [];
photon_x_r(ri2) = [];
photon_h_r(ri2) = [];

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Here, the full plot is created, and
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% subsequently panned across. There are two
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% complete sections here, one for the strong
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% beam and one for the weak beam.

c = {'lightgray','darkgray','lightblue','slateblue','blue'};

if l_or_r == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The strong beam case
    left_shift = min(photon_x_l);
    photon_x_l = photon_x_l-left_shift;
    x_l = x_l - left_shift;
    true_x_l = true_x_l - left_shift;
    
    hold off
    for i = 1:4
        inds = [1; find(photon_class_l == i-1)];
        plot(photon_x_l(inds),photon_h_l(inds),'.','Color',color_call(c{i}),'MarkerSize',(i+2)*1.5)
        hold all
    end
    
    plot(true_x_l,true_h_l,'Color',[0.6 0.6 0.6])
    plot_segs(x_l,h_l,dhfdx_l,40,['''Color'',color_call(''darkblue''),''LineWidth'',2']);
    
    
    for i = 1:4
        legend_inp{i} = ['Photon Type - ',num2str(i-1)];
    end
    
    legend_inp(end+1:end+2) = {'ArcticDEM','ATL06'};
    legend(legend_inp)
    xlabel('Distance Along Track (m)')
    ylabel('Elevation')
    set(gcf,'Color','white')
    maximize
    
    %%
    %%%%%%%%%% Panning Animation
    
    %%%%%%%%%%%%%%%%%%%%% This defines the path for the camera to take
    xwind = 1000;
    ywind = 50;
    inds = find(photon_class_l == 2);
    subinds = find(diff(photon_x_l(inds)) ~= 0);
    inds = inds(subinds+1);
    
    
    xp = linspace(min(photon_x_l)+xwind,max(photon_x_l)-xwind,5000);
    path = smooth_ndh(photon_h_l(inds),2000);
    path = interp1(photon_x_l(inds),path,xp,'linear','extrap');

else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The weak beam case
    left_shift = min(photon_x_r);
    photon_x_r = photon_x_r-left_shift;
    x_r = x_r - left_shift;
    true_x_r = true_x_r - left_shift;
    
    hold off
    for i = 1:4
        inds = [1; find(photon_class_l == i-1)];
        plot(photon_x_r(inds),photon_h_r(inds),'.','Color',color_call(c{i}),'MarkerSize',(i+2)*1.5)
        hold all
    end
    
    plot(true_x_r,true_h_r,'Color',[0.6 0.6 0.6])
    plot_segs(x_r,h_r,dhfdx_r,40,['''Color'',color_call(''darkblue''),''LineWidth'',2']);
   
    
    for i = 1:4
        legend_inp{i} = ['Photon Type - ',num2str(i-1)];
    end
    
    legend_inp(end+1:end+2) = {'ArcticDEM','ATL06'};
    legend(legend_inp)
    xlabel('Distance Along Track (m)')
    ylabel('Elevation')
    

    set(gcf,'Color','white')
    maximize
    
    %%
    %%%%%%%%%% Panning Animation
    
    xwind = 1000;
    ywind = 50;
    inds = find(photon_class_r == 2);
    subinds = find(diff(photon_x_r(inds)) ~= 0);
    inds = inds(subinds+1);
    
    
    xp = linspace(min(photon_x_r)+xwind,max(photon_x_r)-xwind,5000);
    path = smooth_ndh(photon_h_r(inds),2000);
    path = interp1(photon_x_r(inds),path,xp,'linear','extrap');
    
   
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xbounds_seconds = [75 90; ...
    110 125; ...
    131 146; ...
    236 251; ...
    313 328];
xbounds = xbounds_seconds*15;

if l_or_r == 1;
    btype = 'strong';
else
    btype = 'weak';
end

for jj = 1:length(xbounds(:,1))
    
    %loop_steps = find_nearest(xp,xbounds(jj,1)):find_nearest(xp,xbounds(jj,2));
    
    loop_steps = xbounds(jj,1):xbounds(jj,2);
    for i = loop_steps
        
        xlim([xp(i)-xwind xp(i)+xwind])
        ylim([path(i)-ywind path(i)+ywind]);
        generate_frames(['SignalFinder_t',num2str(repeatnum),'_',btype,'_Section',num2str(jj)],['SignalFinder_t',num2str(repeatnum),'_',btype,'_Section',num2str(jj)],i-loop_steps(1)+1)
    end
    
end

for jj = 1:length(xbounds(:,1))
animate_frames(['SignalFinder_t',num2str(repeatnum),'_',btype,'_Section',num2str(jj)],['SignalFinder_t',num2str(repeatnum),'_',btype,'_Section',num2str(jj)],10);
end





    
    