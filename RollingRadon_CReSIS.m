function RollingRadon_CReSIS(filename,window,plotter,movie,ant_or_green)
%% Performs the rolling radon transform slope analysis on a published CReSIS Image.
load(filename)
clearvars slopes slope_x slope_y slope)vals slope_colors
save(filename)

[n1 n2 n3] = fileparts(filename);
o_f_vertical = 3; % - Change this for enhanced Overlap
o_f_horizontal = 0.5;
snr_thresh = 4; % - Change this for the SNR threshold (dB)


window_size = window;
window_size2 = window;
if mod(window_size,2) == 0
    window_size = window_size+1;
end

if exist('plotter') == 0
    plotter = 0;
end
if plotter == 0
    movie = 0;
end
if exist('movie') == 0
    movie = 0;
end
if exist('ant_or_green') == 0
    ant_or_green = 1;
end
if ant_or_green == 1
    image_filename = ['E:\Graduate_Work\Data\CReSIS_Bulk_Download\Slope_Images_Antarctica\',n2,'_SlopeImage.jpg'];
elseif ant_or_green == 2
    image_filename = ['E:\Graduate_Work\Data\CReSIS_Bulk_Download\Slope_Images_Greenland\',n2,'_SlopeImage.jpg'];
else
    image_filename = [pwd,'\',n2,'_SlopeImage.jpg'];
end


%% Set-up the loop
roll_steps = floor(length(data(1,:))/window_size*o_f_horizontal); %Horizontal Steps
roll_steps2 = floor(length(data(:,1))/window_size2*o_f_vertical); %Vertical Steps
slope_colors = b2r(-45,45);
slope_vals = -45:91/length(slope_colors(:,1)):45;
keep_val = 1;

opt_angle = zeros(roll_steps2,roll_steps)*NaN;
status_flag = zeros(size(opt_angle));

if plotter == 1
    subplot(3,4,[1 2 3 5 6 7 9 10 11])
    imagesc(dist,Time*cice/2,filt_data)
    colormap(gray)
    hold all
    plot(xaxis,Surface2*cice/2,':','Color','Blue')
    plot(xaxis,Bottom2*cice/2,':','Color','Red')
    counter2 = 1;
    subplot(3,4,12)
    plot(1,3,'o','Color','red')
    hold all
    plot(1,2,'o','Color','blue')
    plot(1,1,'o','Color','green')
    text(2,4,'Calculated Slope','HorizontalAlignment','left')
    text(2,3,'Outside of Ice Column','HorizontalAlignment','left')
    text(2,2,'SNR too low','HorizontalAlignment','left')
    text(2,1,'Angle Variability Exceeded','HorizontalAlignment','left')
    color_opts = {'red','blue','green'};
    ylim([0 5])
    xlim([0 8])
end





if length(Data(1,:)) > 4000
    steps = ceil(length(Data(1,:))/2000);
    breaks = 1:2000:(length(Data(1,:))+1);
end


for k = 1:steps
    %% Initial Data Preconditioning:
    cice_import
    [x y] = polarstereo_fwd(Latitude,Longitude);
    dist = distance_vector(x,y);
    filt_data = lp(Data)-min(min(lp(Data)));
    [data xaxis yaxis] = regrid(dist,Time*cice/2,filt_data,0,0);
    time = yaxis*2/cice;
    Bottom2 = interp1(dist,interpNaN(Bottom),xaxis);
    Surface2 = interp1(dist,interpNaN(Surface),xaxis);
    
    %%% Perform Radial Spreading Correction
    depth_mat = time2depth_convert(data,time,Surface2);
    data = data + RadialSpreading(depth_mat,0,1);
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The Rolling Portion
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    snr_counter = 1;
    counter1 = 1;
    updater = 10;
    
    for i = 1:roll_steps
        %% Determine the Window area for the horizontal dimension
        start = (i-1)*floor(window_size2/o_f_horizontal)+1;
        stop = min([(i-1)*floor(window_size2/o_f_horizontal)+window_size2 length(data(1,:))]);
        opt_x(i+(k-1)*2000) = xaxis(stop-floor((window_size2-1)/2));
        for j = 1:roll_steps2
            %% Determine the Window area for the vertical dimension
            start2 = (j-1)*floor(window_size2/o_f_vertical)+1;
            stop2 = min([(j-1)*floor(window_size2/o_f_vertical)+window_size2 length(data(:,1))]);
            opt_y(j) = yaxis(stop2-floor((window_size2-1)/2));
            
            %% If window falls between the bed and surface, continue, otherwise skip
            if exist('Bottom') == 1
                if time(stop2) < Bottom2(stop) & time(start2) > Surface2(stop-floor((window_size2-1)/2))
                    skipflag = 0;
                else
                    skipflag = 1;
                    status_flag(j,i) = 1;
                end
            else
                skipflag = 0;
            end
            
            %% If the window isn't skipped due to falling outside the ice column, the signal to noise criteria is tested
            if skipflag == 0;
                radon_data = data(start2:stop2,start:stop);
                
                %%% Compute Signal to Noise for final restriction
                
                snr_max = max(radon_data,[],2);
                snr_max = max([snr_max(7:end) snr_max(6:end-1) snr_max(5:end-2) snr_max(4:end-3) snr_max(3:end-4) snr_max(2:end-5) snr_max(1:end-6)],[],2);
                snr_min = min(radon_data,[],2);
                snr_min = min([snr_min(7:end) snr_min(6:end-1) snr_min(5:end-2) snr_min(4:end-3) snr_min(3:end-4) snr_min(2:end-5) snr_min(1:end-6)],[],2);
                snr = max(snr_max-snr_min);
                
                %%% Tests the SNR Criterion
                if snr < snr_thresh
                    opt_angle(j,i) = NaN;
                    skipflag = 1;
                    status_flag(j,i) = 2;
                else
                    [opt_angle(j,i) rd] = radon_ndh(xaxis(start:stop),yaxis(start2:stop2),radon_data,0,0);
                end
            else
                opt_angle(j,i) = NaN;
            end
            
            %% If the Window still isn't skipped, this test makes sure the computed slopes don't vary dramatically over space
            if i ~= 1 | j~= 1
                if abs(last_val-opt_angle(j,i)) > 5
                    last_val = opt_angle(j,i);
                    opt_angle(j,i) = NaN;
                    status_flag(j,i) = 3;
                end
            else
                last_val = opt_angle(j,i+(k-1)*2000)(j,i);
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% This section does the rolling plotter (for debug purposes)
            if plotter == 1
                
                subplot(3,4,[1 2 3 5 6 7 9 10 11])
                if i ~= 1 | j~= 1
                    delete(a)
                    if abs(last_val-opt_angle(j,i+(k-1)*2000)(j,i)) > 10
                        keep_val = 0;
                        last_val = opt_angle(j,i+(k-1)*2000)(j,i);
                        opt_angle(j,i+(k-1)*2000)(j,i) = NaN;
                    else
                        keep_val = 1;
                    end
                else
                    last_val = opt_angle(j,i+(k-1)*2000)(j,i);
                end
                a = plot([xaxis(start) xaxis(start) xaxis(stop) xaxis(stop) xaxis(start)],[yaxis(start2) yaxis(stop2) yaxis(stop2) yaxis(start2) yaxis(start2)],'Color','blue','LineWidth',2);
                
                if skipflag == 0 % If there was no value computed, it skips plotting the dot
                    if abs(opt_angle(j,i+(k-1)*2000)(j,i)) < 45 & keep_val == 1
                        tc = find_nearest(slope_vals,opt_angle(j,i+(k-1)*2000)(j,i));
                        plot(opt_x(i+(k-1)*2000),opt_y(j),'o','MarkerFaceColor',slope_colors(tc,:),'Color',slope_colors(tc,:))
                    else
                        opt_angle(j,i+(k-1)*2000)(j,i+(k-1)*2000) = NaN;
                    end
                    
                    
                    subplot(3,4,4)
                    imagesc(radon_data)
                    subplot(3,4,8)
                    imagesc(rd)
                    
                    %             subplot(3,4,12)
                    %             xlim([-1 1])
                    %             ylim([-1 1])
                    %             namer = text(0,0,num2str(opt_angle(j,i+(k-1)*2000)(j,i+(k-1)*2000)));
                    pause(0.03)
                    %             delete(namer)
                    if movie == 1
                        mov(counter1) = getframe(gcf);
                        counter1 = counter1+1;
                    end
                else
                    
                    plot(opt_x(i+(k-1)*2000),opt_y(j),'o','Color',color_opts{status_flag(j,i)})
                    pause(0.01)
                end
            end
            %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        if round(100*i/roll_steps) >= updater
            disp(['Progress - ',num2str(round(100*i/roll_steps))])
            updater = updater+10;
        end
        
    end
    
    if movie == 1
        vid_ob = VideoWriter([date,'-roll_radon11.avi'],'Motion JPEG AVI');
        vid_ob.FrameRate = 15;
        vid_ob.Quality = 75;
        
        open(vid_ob)
        writeVideo(vid_ob,mov)
        close(vid_ob)
    end
end




%% Produce the final results image
slope_x = opt_x;
slope_y = opt_y;
slopes = opt_angle;





%%% Interpolate the Grid
disp('Writing Data')
counter2 = 1;
for i = 1:length(slope_x)
    for j = 1:length(slope_y)
        
        value_vec(counter2,:) = [slope_x(i) slope_y(j) slopes(j,i)];
        counter2 = counter2+1;
        
    end
end


%%%%%%%%%%%%%%%% THIS ORIGINALLY REGRIDDED AND SMOOTHED THE RESULTS %%%%%%%
slopegrid_x = min(slope_x):20:max(slope_x);
slopegrid_y = min(slope_y):20:max(slope_y);

slopegrid = griddata(value_vec(:,1),value_vec(:,2),value_vec(:,3),slopegrid_x',slopegrid_y);
%slopegrid = conv2(slopegrid, ones(100), 'same');
clearvars -except slope_x slope_y slopes filename image_filename slopegrid_x slopegrid_y slopegrid
load(filename)
save(filename)

clearvars -except image_filename Latitude Longitude slope_x slope_y slopes Data Time Surface Bottom slopegrid_x slopegrid_y slopegrid

disp('Writing Figure')
cice_import
[x y] = polarstereo_fwd(Latitude,Longitude);
dist = distance_vector(x,y);





imagesc(dist,Time*cice/2,lp(Data))
colormap(gray)
a1 = getRGB_imagesc(lp(Data));

close all
final_fig = figure();
set(final_fig,'Position',[1000 639 1400 699])
imagesc(dist,Time*cice/2,a1)
hold all
plot(dist,Surface*cice/2,':','Color','Blue')
plot(dist,Bottom*cice/2,':','Color','Red')


colormap(b2r2(-15,15));

%%%%%%%%% First Implementation of the plot (gridded data)
row_indecies = find(min(isnan(slopegrid),[],2) == 0);
h = imagesc(slopegrid_x,slopegrid_y(row_indecies),slopegrid(row_indecies,:));
set(h,'Alphadata',~isnan(slopegrid(row_indecies,:))*0.5)

% %%%%%%%%%% Second Implementation of the plot (scattered data)
% indecies = combvec(slope_x,slope_y);
% slope_vec = (reshape(slopes',[prod(size(slopes)) 1]));
% h = scatter(indecies(1,~isnan(slope_vec)),indecies(2,~isnan(slope_vec)),20,slope_vec(~isnan(slope_vec)),'fill');
% pause(1)
% hmarks = h.MarkerHandle;
% %%%        Made Transparent
% %pause(1)
% %temp_color = get(hmarks,'FaceColorData');
% %hmarks.FaceColorData = 255*0.5*(1-isnan(reshape(slopes',[prod(size(slopes)) 1])));

colorbar;

pause(1)

saveas(final_fig,image_filename)

clear all
close all
disp(['Line Complete'])


end