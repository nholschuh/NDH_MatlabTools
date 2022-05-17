function animate_cresis_swath(in_file,surfdir,demdir,musicdir,true_datadir);
% (C) Nick Holschuh - U. of Washington - 2018 (Nick.Holschuh@gmail.com)
% Animates the cresis music output, showing the swath image, the radargram,
% and the radar cross section
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% filename - The filename (-Data), containing the date and segment number
% surfdir - The 'CSARP_*****' name for the surf data
% demdir - The 'CSARP_*****' name for the surf data
% musicdir - The 'CSARP_*****' name for the music data
% true_datadir - The root directory that houses the season name folders 
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


edge_trim = 11;
end_trim = 20;

single_image_flag = 0;
tframe = 1;

frm_n = in_file(1:11);
seg_n = in_file(13:15);
in_file = ['Data_',in_file];
[s_prefix ant_or_gre] = cresis_season(in_file);
s_prefix = [s_prefix,'/'];

if exist('true_datadir') == 1
    cont_dir = [];
else
    if ant_or_gre == 1
        cont_dir = 'Antarctica';
    else
        cont_dir = 'Greenland';
    end
end

if exist('surfdir') == 0
    surfdir = 'CSARP_surf/';
else
    surfdir = [surfdir,'/'];
end

if exist('demdir') == 0
    demdir = 'CSARP_DEM/';
else
    demdir = [demdir,'/'];
end

if exist('musicdir') == 0
    musicdir = 'CSARP_music/';
else
    musicdir = [musicdir,'/'];
end

if exist('true_datadir') == 0
    true_datadir = datadir;
end


%%%%% Load DEM Data
[bottom_x bottom_y bottom_data across_index] = read_swathcsv([true_datadir,cont_dir,s_prefix,demdir,frm_n,'/',frm_n,'_',seg_n,'_bottom.csv'],edge_trim,end_trim);
di_swath = find(min(across_index(:,1)) == across_index(:,1));
dx_swath = distance_vector(bottom_x(di_swath,:),bottom_y(di_swath,:),1);

bottom_xy = [matrix_to_vector(bottom_x) matrix_to_vector(bottom_y)];
bottom_zz = matrix_to_vector(bottom_data);


%%%%% Load Music Data
load([true_datadir,cont_dir,s_prefix,musicdir,frm_n,'/',in_file,'.mat']);
fake_theta = linspace(min(theta),max(theta),length(theta));

%%%%% Load the Surfaces
load([true_datadir,cont_dir,s_prefix,surfdir,frm_n,'/',in_file,'.mat']);
ss = load([true_datadir,cont_dir,s_prefix,surfdir,frm_n,'/',in_file,'.mat'],'surf');


for i = 1:length(ss.surf)
    if length(ss.surf(i).name) == 6
        if ss.surf(i).name == 'bottom'
            bottom_ind = i;
        end
    end
end

[x y] = polarstereo_fwd(Latitude(1:length(bottom_x(1,:))),Longitude(1:length(bottom_x(1,:))));
bs = 90 - segment_bearing([x(1:end-1)' y(1:end-1)'],[x(2:end)' y(2:end)']);
bs(end+1) = bs(end);


dv = 700;
dv2 = nanmean(dx_swath)/2;

edge1 = [x' y'];
edge1(:,1) = edge1(:,1) + cos(deg2rad(bs-90))*dv;
edge1(:,2) = edge1(:,2) + sin(deg2rad(bs-90))*dv;

edge2 = [x' y'];
edge2(:,1) = edge2(:,1) - cos(deg2rad(bs-90))*dv;
edge2(:,2) = edge2(:,2) - sin(deg2rad(bs-90))*dv;

edge1a = [x' y'];
edge1a(:,1) = edge1a(:,1) + cos(deg2rad(bs-90))*dv2';
edge1a(:,2) = edge1a(:,2) + sin(deg2rad(bs-90))*dv2';

edge2a = [x' y'];
edge2a(:,1) = edge2a(:,1) - cos(deg2rad(bs-90))*dv2';
edge2a(:,2) = edge2a(:,2) - sin(deg2rad(bs-90))*dv2';

dists = distance_vector(x,y);

%%

figure(1)
maximize

[cx_theta cx_time] = meshgrid(rad2deg(theta),Time*10^6);


frame_skip = 10;
if single_image_flag == 1
    frame_count = tframe;
else
    frame_count = 1:floor(length(Data(1,:))/frame_skip);
end


max_y = min([max(removeNaN(ss.surf(bottom_ind).y(32,:)))*10^6+2 max(Time*10^6)]);

loopopts = find(~isnan(edge1a(:,1)));
frame_counter = 1;


for i = loopopts(1:frame_skip:end)';
    
    %ground_points = find_nearest_xy(bottom_xy(:,1:2),line_fill([edge1a(i,:); edge2a(i,:)],1,200));
    
    plane_height = 2300;
    
    %%%%%%%%%%%%%%%%%%%%% Here we plot the swath and a plane overflying it
    aa = subplot(4,4,[1:3]);
    hold off
    scatter3(bottom_xy(:,1),bottom_xy(:,2),bottom_zz(:,1),3,bottom_zz,'filled');
    hold all
    plot3(bottom_x(:,i),bottom_y(:,i),bottom_data(:,i)+50,'Color','red');
    plot3(x(i),y(i),plane_height,'.','Color','red','MarkerSize',10)
    plot3([edge1(i,1) edge2(i,1)],[edge1(i,2) edge2(i,2)],[plane_height plane_height],'Color','red');
    
    
    %%% The radiation lines to the swath
    plot3([bottom_x(1,i) x(i)],[bottom_y(1,i) y(i)],[bottom_data(1,i)+50 plane_height],':','Color','red');
    plot3([bottom_x(end,i) x(i)],[bottom_y(end,i) y(i)],[bottom_data(end,i)+50 plane_height],':','Color','red');
    
    
    %%%%%%%%%%%%%%%%%%%%%% Determine the view orientation
    
    vangle = mod(median(segment_bearing([x' y'])),360);
    
    view(vangle+90,20.4);
    xlim([min(bottom_xy(:,1)) max(bottom_xy(:,1))])
    ylim([min(bottom_xy(:,2)) max(bottom_xy(:,2))])
    colormap(aa,gmt_to_matlab_colormap(1))
    caxis([mean(bottom_zz)-2*std(bottom_zz)-600 mean(bottom_zz)+2*std(bottom_zz)+200])
    axis_equal(0.05)
    
    grid off
    
    
    %%%%%%%%%%%%%%%%%%%%% Here we plot the Radargram with the trace marked
    a = subplot(4,4,[5:7 9:11 13:15]);
    hold off
    imagesc(dists/1000,Time*10^6,lp(Data))
    hold all
    plot_indicator_lines(dists(i)/1000,2,'red',1,':')
    
    if isnan(ss.surf(bottom_ind).y(32,i)) == 0
    plot(dists(i)/1000,ss.surf(bottom_ind).y(32,i)*10^6,'o','Color','red','MarkerFaceColor','red')
    end
    colormap(a,flipud(gray))
    caxis([15 30])
    
    
    NDH_Style()
    xlabel('Distance (km)')
    ylabel('Two-way Travel Time (\mu s)')
    
    
    %%%%%%%%%%%%%%%%%%%%% Here we plot the Radar cross section
    b = subplot(4,4,[8 12 16]);
    hold off
    plot(1,1)
    pcolor(cx_theta,cx_time,lp(squeeze(Tomo.img(:,:,i))))
    hold all
    real_inds = find(ss.surf(bottom_ind).y(:,i) ~= 0);
    %plot(rad2deg(theta(real_inds)),ss.surf(bottom_ind).y(real_inds,i)*10^6,':','Color','red','LineWidth',2)
    colormap(b,flipud(gray))
    shading interp
    caxis([15 30])
    ylim([0 40])
    xlim(rad2deg([min(theta) max(theta)]))
    set(gca,'YDir','reverse')
    

    NDH_Style()
    xlabel('Flight Angle (^o)')

    
    linkaxes([a b],'y')
    
    
    ylim([0 max_y])

    
    axes(aa)
    grow_axis(2)
    axis off
    
    
    pause(0.01)
    if single_image_flag == 0
        generate_frames(['temp'],['temp'],frame_counter);
        frame_counter = frame_counter+1;
    else
        pdf_ndh('PaperFigure_Flight_XS',0,0,1);
    end
end

if single_image_flag == 0
    animate_frames(['Manuscript_CX_',frm_n,'_',seg_n,'_Anim'],['temp'],160/frame_skip);
else
    
end














