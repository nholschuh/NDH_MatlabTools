function [slopegrid_x slopegrid_y slopegrid opt_x opt_y opt_angle] = RollingRadon(data_x_or_filename,data_y,Data,window,angle_thresh,plotter,surface_bottom,movie_flag,max_frequency)
% (C) Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Performs the rolling radon transform slope analysis on a set of data
% {optimized for the CReSIS data format, but can be used for any data).
%
% Official version for all use, 11/12/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% data_x_or_filename - Either the X-axis or the name of a CReSIS flight
%                      file
% data_y - values for the Y-axis ***(ignored if filename provided)
% Data - the data grid           ***(ignored if filename provided)
% window - this defines the size of the rolling window
% angle_thresh - this value is the maximum slope useable;
% plotter - 1, generates the debug plots
% surface_bottom - a vector containing the surface and bottom picks
% movie_flag - 1, Records the debug plots (must have plotter == 1)
% max_frequency - this sets the scale for interpolation, based on the
%                 highest frequency of interest
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


o_f_vertical = 2; % - Change this for enhanced Overlap of individual slope cells
o_f_horizontal = 8;
snr_thresh = 4; % - Change this for the SNR threshold (dB) - Higher Value More Restrictive
snr_fac = 0.7; % - Secondary SNR evaluation - the number of standard deviations below the mean power for the trace for a cutoff (lower value more restrictive)
pr = 0.05; % - The rate at which the debug plotter updates
at = 10; % - This sets the angle threshold where it is determined to be too variable
vr = 20; % - This sets how many samples in a row need to deviate before the code recognizes it is actually a new value


if exist('surface_bottom') == 0
    surface_bottom = 0;
end
if exist('movie_flag') == 0
    movie_flag = 0;
end
if exist('max_frequency') == 0
   [fd faxis] = fft_ndh(Data(:,round(length(Data(1,:))/2)),data_y);
   max_frequency = faxis(find(max(fd) == fd));
end

    

if mod(window,2) == 0 % Ensure the windowsize is an odd number
    window = window+1;
end
window_size = window;
window_size2 = window;

if floor(window_size/o_f_horizontal) == 0
    o_f_horizontal = window_size;
end
if floor(window_size/o_f_vertical) == 0
    o_f_vertical = window_size2;
end

xstep_roll = floor(window_size/o_f_horizontal);
ystep_roll = floor(window_size2/o_f_vertical);

%%%%%%%%%%%%% Check for all of the necessary input vars
if exist('plotter') == 0
    plotter = 0;
end
if plotter == 0
    movie_flag = 0;
end
if exist('movie') == 0
    movie_flag = 0;
end

if length(angle_thresh) == 1
    angle_thresh(2) = angle_thresh(1)-5;
end


%%%%%%%%%%%% Deal with either CReSIS Input or general input

if isstr(data_x_or_filename) == 1 % The case where it is a filename
    %%%%%%%% You need to generate the following values:
    %%% dist
    %%% data_y
    %%% Data
    
    load(data_x_or_filename)
    
    if exist('x') == 0
        [x y] = polarstereo_fwd(Latitude,Longitude);
    end
    if Time(2)-Time(1) > 1e-6
        Time = Time*10^-6;
    end
    
    dist = distance_vector(x,y);
    data_y = Time;
    
    Data = lp(Data);
    
else
    dist = data_x_or_filename; 
    
    if surface_bottom ~= 0
        surf_bot_dim = size(surface_bottom);
        if min(surf_bot_dim) == 1
            Surface = surface_bottom;
        else
            if surf_bot_dim(1) == min(surf_bot_dim)
                Surface = surface_bottom(1,:);
                Bottom = surface_bottom(2,:);
            else
                Surface = surface_bottom(:,1);
                Bottom = surface_bottom(:,2);
            end
        end
    end
end

%% Set-up the loop
filt_data = lp(Data);

clearvars -except Data dist data_y Surface Bottom window_size window_size2 o_f_vertical o_f_horizontal snr_thresh plotter movie_flag snr_fac max_frequency xstep_roll ystep_roll angle_thresh pr vr at
cice_import


if plotter == 1
    subplot(3,4,[1 2 3 5 6 7 9 10 11])
    if exist('max_frequency') == 1
        cice_import
        imagesc(dist,data_y*cice/2,Data);
    else
        imagesc(dist,data_y,Data)
    end
    colormap(gray)
    hold all
    if exist('Bottom') == 1
         plot(dist,Surface*cice/2,':','Color','Blue')
         plot(dist,Bottom*cice/2,':','Color','Red')
    end
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
    axis off
    set(gcf,'Color','white')
    
    if movie_flag == 1 && exist('Radon_Animation_Frames') == 0
        mkdir('Radon_Animation_Frames')
    end
end



overload_factor = 1000; % This breaks the initial computation into cells smaller than the prescribed value, to save on memory

if length(Data(1,:)) > overload_factor
    steps = ceil(length(Data(1,:))/overload_factor);
    breaks = [1:overload_factor:(length(Data(1,:))+1) (length(Data(1,:))+1)];
else
    steps = 1;
    breaks = [1 length(Data(1,:))];
end


    slope_colors = b2r2(-angle_thresh(1),angle_thresh(1));
    slope_vals = -angle_thresh(1):(2*angle_thresh(1)+1)/length(slope_colors(:,1)):angle_thresh(1);
    total_time = 0;
for k = 1:steps
    disp(['Starting Window ',num2str(k),' of ',num2str(steps),', Total Time - ',sprintf('%.02f',total_time),' min'])
    
    %% Initial Data Preconditioning:
    clearvars xaxis yaxis data
    

    
    %%%% THIS IS THE INTERPOLATION STEP! THIS IS CRITICAL TO THE PROPER
    %%%% FUNCTIONING OF THE CODE
    filt_data = Data(:,breaks(k):breaks(k+1)-1);
    if exist('max_frequency') == 1
        [data xaxis yaxis] = regrid(dist(breaks(k):breaks(k+1)-1),data_y,filt_data,1,max_frequency,'linear');
        time = yaxis;
        yaxis = yaxis*cice/2;
    else
        [data xaxis yaxis] = regrid(dist(breaks(k):breaks(k+1)-1),data_y,filt_data,0,0);
    end
    
    if exist('Bottom') == 1
        Bottom2 = interp1(dist(breaks(k):breaks(k+1)-1),interpNaN(Bottom(breaks(k):breaks(k+1)-1)),xaxis);
        Surface2 = interp1(dist(breaks(k):breaks(k+1)-1),interpNaN(Surface(breaks(k):breaks(k+1)-1)),xaxis);
    end
    
    %% This determines if it is the first subset of the data, if so variables are initialized
    if exist('previous_xsteps') == 0
        previous_xsteps = 0;
    end
    if k < steps
        roll_steps = round((length(data(1,:))-window_size)/xstep_roll); %Horizontal Steps
    else
        roll_steps = floor((length(data(1,:))-window_size)/xstep_roll); %Horizontal Steps
    end
    
    roll_steps2 = round((length(data(:,1))-window_size2)/ystep_roll); %Vertical Steps

    

    keep_val = 1;
    
    if exist('opt_angle') == 0
        opt_angle = zeros(roll_steps2,roll_steps)*NaN;
        status_flag = zeros(size(opt_angle));
        means = zeros(size(opt_angle));
    else
        opt_angle = [opt_angle zeros(roll_steps2,roll_steps)*NaN];
        status_flag = [status_flag zeros(roll_steps2,roll_steps)];
        means = [means zeros(roll_steps2,roll_steps)];
    end
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The Rolling Portion
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end_counter1 = 0;
    end_counter2 = 0;
    snr_counter = 1;
    counter1 = 1;
    updater = 10;
    
    
    tic
    for i = 1:roll_steps
        
        %% Restart the variability record
        variability_record = [];
        last_val = [];
        
        %% Determine the Window area for the horizontal dimension
        start = (i-1)*xstep_roll+1;
        stop = min([start+window_size-1 length(data(1,:))]);
        opt_x(i+previous_xsteps) = xaxis(stop-floor((window_size-1)/2));
        if i > 1
            if opt_x(end) <= opt_x(end-1)
                end_counter1 = end_counter1+1;
                opt_x(end) = xaxis(stop-floor((window_size-1)/2)+end_counter1);
            else
                end_counter1 = 0;
            end
        end
        
        centerx_ind = stop-floor((window_size-1)/2);
        
        %%%% Computes the vertical power profile through the center of the
        %%%% window, as well as it's mean value and standard deviation
        smooth_wind_frac = 0.1; % percentage of total trace length
        
        %%%%% This works for amplitude data
        %power_dist = abs(conv(data(:,centerx_ind),ones(round(length(data(:,centerx_ind))*smooth_wind_frac),1),'same')./conv(ones(size(data(:,centerx_ind))),ones(round(length(data(:,centerx_ind))*smooth_wind_frac),1),'same'));
        %power_dist_inds = (isnan(power_dist) == 0 & isinf(power_dist) == 0);
        %power_dist_mean = abs(mean(power_dist));
        
        %%%%% This is for power data
        power_dist = conv(data(:,centerx_ind),ones(round(length(data(:,centerx_ind))*smooth_wind_frac),1),'same')./conv(ones(size(data(:,centerx_ind))),ones(round(length(data(:,centerx_ind))*smooth_wind_frac),1),'same');
        power_dist_inds = (isnan(power_dist) == 0 & isinf(power_dist) == 0);
        power_dist_mean = mean(power_dist(power_dist_inds));

        power_dist_std = std(power_dist(power_dist_inds));

        
        for j = 1:roll_steps2

            %% Determine the Window area for the vertical dimension
            start2 = (j-1)*floor(window_size2/o_f_vertical)+1;
            stop2 = min([(j-1)*floor(window_size2/o_f_vertical)+window_size2 length(data(:,1))]);
            opt_y(j) = yaxis(stop2-floor((stop2-start2)/2));
            centery_ind = stop2-floor((stop2-start2)/2);
            
            %% If window falls between the bed and surface, continue, otherwise skip
            if i > 1
                if opt_x(end) <= opt_x(end-1)
                    end_counter2 = end_counter2+1;
                    opt_x(end) = xaxis(stop2-floor((window_size2-1)/2)+end_counter2);
                else
                    end_counter2 = 0;
                end
            end
            
            if exist('Bottom') == 1
                if time(centery_ind) < Bottom2(centerx_ind) & time(centery_ind) > Surface2(centerx_ind)
                    skipflag = 0;
                else
                    skipflag = 1;
                    status_flag(j,i+previous_xsteps) = 1;
                end
            else
                skipflag = 0;
            end
            
            %% If the window isn't skipped due to falling outside the ice column, the signal to noise criteria is tested
            if skipflag == 0;
                
                radon_data = data(start2:stop2,start:stop);
                means(j,i+previous_xsteps) = mean(mean(radon_data));
                
                %%% Compute Signal to Noise for final restriction
                snr_win_data = data(start2:stop2,centerx_ind);
                snr_std = std(snr_win_data);
                snr = 2*snr_std;
                
                %%% Tests the SNR Criterion
                if snr < snr_thresh | power_dist(centery_ind) < power_dist_mean - snr_fac*power_dist_std
                    opt_angle(j,i+previous_xsteps) = NaN;
                    skipflag = 1;
                    status_flag(j,i+previous_xsteps) = 2;
                else
                    
                    if length(xaxis(start:stop)) == 0
                        keyboard
                    end
                    
                    [opt_angle(j,i+previous_xsteps) rd rad_angle_axis trash rsnr] = radon_ndh(xaxis(start:stop),yaxis(start2:stop2),radon_data,angle_thresh(1),0,0);
                    if isnan(opt_angle(j,i+previous_xsteps)) == 1
                        status_flag(j,i+previous_xsteps) = 2;
                    end
                    
                    %%% This identifies if the value exceeds the second
                    %%% entry in angle_thresh
                    if abs(opt_angle(j,i+previous_xsteps)) > angle_thresh(2)
                        status_flag(j,i+previous_xsteps) = 3;
                        opt_angle(j,i+previous_xsteps) = NaN;
                    end                        
                end
            else
                opt_angle(j,i+previous_xsteps) = NaN;
            end
       
            %% If the Window still isn't skipped, this test makes sure the computed slopes don't vary dramatically over space
            
            if skipflag == 0
                        if j~= 1     % Ensures that you are not in the first row or column
                            if abs(last_val-opt_angle(j,i+previous_xsteps)) > at
                                variability_record = [variability_record opt_angle(j,i+previous_xsteps)];
                                
                                if length(variability_record) >= vr; %%% If five in a row don't fit the smoothness constraint, it accepts those values instead and starts over
                                    opt_angle(j-vr+1:j,i+previous_xsteps) = variability_record(1:vr);
                                    last_val = opt_angle(j,i+previous_xsteps);
                                    status_flag(j-vr+1:j,i+previous_xsteps) = 0;
                                    variability_record = [];
                                else                                
                                    opt_angle(j,i+previous_xsteps) = last_val;
                                    last_val = opt_angle(j,i+previous_xsteps);
                                    status_flag(j,i+previous_xsteps) = 3;
                                    skipflag = 1;
                                end
                            else
                                last_val = opt_angle(j,i+previous_xsteps);
                                variability_record = [];
                            end
                        else
                            last_val = opt_angle(j,i+previous_xsteps);
                            variability_record = [];
                        end
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% This section does the rolling plotter (for debug purposes)
            if plotter == 1
                
                subplot(3,4,[1 2 3 5 6 7 9 10 11])
                if i ~= 1 | j ~= 1 | k ~= 1
                    delete(a)
                    if abs(last_val-opt_angle(j,i+previous_xsteps)) > 10
                        keep_val = 0;
                        last_val = opt_angle(j,i+previous_xsteps);
                        opt_angle(j,i+previous_xsteps) = NaN;
                    else
                        keep_val = 1;
                    end
                else
                    last_val = opt_angle(j,i+previous_xsteps);
                end
                % Plot the blue box
                a = plot([xaxis(start) xaxis(start) xaxis(stop) xaxis(stop) xaxis(start)],[yaxis(start2) yaxis(stop2) yaxis(stop2) yaxis(start2) yaxis(start2)],'Color','blue','LineWidth',2);
                
                if skipflag == 0 & isnan(opt_angle(j,i+previous_xsteps)) == 0 % If there was no value computed, it skips plotting the dot
                    tc = find_nearest(slope_vals,opt_angle(j,i+previous_xsteps));
                    plot(opt_x(i+previous_xsteps),opt_y(j),'o','MarkerFaceColor',slope_colors(tc,:),'Color',slope_colors(tc,:))
                else
                     plot(opt_x(i+previous_xsteps),opt_y(j),'o','Color',color_opts{status_flag(j,i+previous_xsteps)})
                end
                    
                if exist('rad_angle_axis') == 1    
                    subplot(3,4,4)
                    hold off
                    imagesc(radon_data)
                    title(['Data Window'])
                    %title(['Data Window - SNR ',sprintf('%.02f',snr)])
                    plot_indicator_lines([tan(deg2rad(-opt_angle(j,i+previous_xsteps))) length(radon_data)/2 length(radon_data)/2],3,'blue')
 
                    
                    subplot(3,4,8)
                    imagesc(rad_angle_axis-90,1:length(rd(:,1)),rd.^2)
                    hold all
                    if isnan(opt_angle(j,i+previous_xsteps)) == 1
                        plot(0,length(rd(:,1))/2,'o','Color','blue','MarkerFaceColor','blue');
                    else
                        plot_indicator_lines(opt_angle(j,i+previous_xsteps),2,'blue');
                    end
                    hold off
                    
                    title(['Radon Transform'])
                    %title(['Radon Transform - RSNR',sprintf('%.02f',rsnr)])
                    
                    %             subplot(3,4,12)
                    %             xlim([-1 1])
                    %             ylim([-1 1])
                    %             namer = text(0,0,num2str(opt_angle(j,i+(k-1)*overload_factor)(j,i+(k-1)*overload_factor)));
                    pause(pr)
                    %             delete(namer)
                    if movie_flag == 1
                        
                        generate_frames('RRadon_Frame','Radon_Animation_Frames',counter1)
                        counter1 = counter1 + 1;
                    end
                end
                    
            end
        end
            %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if round(100*i/roll_steps) >= updater
            disp(['         RollStep Progress - ',num2str(i),'/',num2str(roll_steps),' ',num2str(round(100*i/roll_steps)),'%, ',sprintf('%0.2f',toc/60),' minutes'])
            updater = updater+10;
        end
        
        
    end
    if movie_flag == 1
      %%%%%%%%%%%%% Previous implementation of the movie writing
      %%%%%%%%%%%%% which did everything within matlab
%     %%%%         vid_ob = VideoWriter([date,'-roll_radon11.avi'],'Motion JPEG AVI');
%     %%%%         vid_ob.FrameRate = 15;
%     %%%%         vid_ob.Quality = 75;
%     %%%%         
%     %%%%         open(vid_ob)
%     %%%%         writeVideo(vid_ob,mov)
%     %%%%         close(vid_ob)
    end
    
        previous_xsteps = length(opt_x);
        total_time = total_time + toc/60;
end




%% Produce the final results image
zero_inds = find(opt_x ~= 0);
slope_x = opt_x(zero_inds);
slope_y = opt_y;
slopes = opt_angle(:,zero_inds);
means = means(:,zero_inds);



% %%%% This filters out points whose slope values are more than +- 20 
% %%%% than their neighbor;
% compare_grid = conv2(abs(NaN2value(slopes,0)),ones(3),'same');
% nan_flag_values = find(abs(slopes) > abs(compare_grid/4.5) | slopes > 50);% | abs(slopes) < abs(compare_grid/18));
% slopes(nan_flag_values) = NaN;
% 
% mask_vals = 1-[conv2(double(isnan(slopes)),ones(5),'same') > 13];
% mask2 = [means > 0];
% morethan4_adjacent_nans = find(mask_vals == 0);
% 
% slopes(morethan4_adjacent_nans) = 0;
% slopes = slopes.*mask2;


slopedebug = 0;
if slopedebug == 1
    subplot(2,1,1)
    imagesc(opt_angle(:,1:length(slopes)))
    subplot(2,1,2)
    imagesc(slopes)
end


%%% Interpolate the Grid
disp('Writing Data')



%% This section defines the final interpolation method
interp_method = 0;
%0 - No interpolation (just output opt_angle values)
%1 - 1D interpolation in time for each slope column
%2 - 2D interpolation
%3 - Standard Grid regridding

if interp_method == 0
    slopegrid_x = opt_x;
    slopegrid_y = opt_y;
    slopegrid = opt_angle;
elseif interp_method == 1
    slopegrid_x = slope_x;
    dy = 10;
    slopegrid_y = min(slope_y):dy:max(slope_y);
    
    %%% top and bottom pad
    slopegrid_y = [min(slopegrid_y)-20*dy:dy:min(slopegrid_y)-dy slopegrid_y max(slopegrid_y)+dy:dy:max(slopegrid_y)+20*dy];
    slope_y_temp = [min(slopegrid_y)-20*dy:5:min(slopegrid_y)-dy slope_y max(slopegrid_y)+dy:5:max(slopegrid_y)+20*dy];
    pad_width = length(min(slopegrid_y)-20*dy:5:min(slopegrid_y)-dy);
    
    slopes = [zeros(pad_width,length(slopes(1,:))); slopes; zeros(pad_width,length(slopes(1,:)))];
    
    slope_nonan = 1-[isnan(slopes)];
    
    for i = 1:length(slopegrid_x)
        slopegrid(:,i) = interp1(slope_y_temp(find(slope_nonan(:,i))),slopes(find(slope_nonan(:,i)),i),slopegrid_y,'spline');
    end
    filt_size = 5;
    slopegrid = conv2(slopegrid, ones(filt_size), 'same')./filt_size^2;
    
    %%% Remove the padding
    slopes = slopes(pad_width+1:end-pad_width-1,:);
    slopegrid = slopegrid(21:end-21,:);
    slopegrid_y = slopegrid_y(21:end-21);
    
elseif interp_method == 2
    counter2 = 1;
    for i = 1:length(slope_x)
        for j = 1:length(slope_y)
            
            value_vec(counter2,:) = [slope_x(i) slope_y(j) slopes(j,i)];
            counter2 = counter2+1;
            
        end
    end
    
    
    %%%%%%%%%%%%%%%% THIS ORIGINALLY REGRIDDED AND SMOOTHED THE RESULTS %%%%%%%
    slopegrid_x = min(slope_x):20:max(slope_x);
    slopegrid_y = min(slope_y):5:max(slope_y);
    
    value_vec = removeNaN(value_vec);
    slopegrid = griddata(value_vec(:,1),value_vec(:,2),value_vec(:,3),slopegrid_x',slopegrid_y);
elseif interp_method == 3
    opt_angle2 = opt_angle;
    opt_angle2(find(isnan(opt_angle) == 1)) = 0;
    
    if exist('time') == 1
        cice_import;
        [slopegrid  slopegrid_x slopegrid_y] = regrid(opt_x,opt_y*2/cice,opt_angle2,dist,data_y);   
    else
        [slopegrid  slopegrid_x slopegrid_y] = regrid(opt_x,opt_y,opt_angle2,dist,data_y);
    end
end

slopegrid = slopegrid*-1;



%%% This should maybe actually be in there, I commented it out for testing
clearvars -except slope_x slope_y slopes filename image_filename slopegrid_x slopegrid_y slopegrid dist data_y Data opt_x opt_y opt_angle

%clearvars -except filename image_filename Latitude Longitude x y slope_x slope_y slopes Data Time Surface Bottom slopegrid_x slopegrid_y slopegrid



disp('Writing Figure')


final_fig = figure();
set(final_fig,'Position',[1000 639 1400 699])
imagesc(dist,data_y,Data)
colormap(gray)
colorlock

if exist('Bottom') == 1
    plot(dist,Surface*cice/2,':','Color','Blue')
    plot(dist,Bottom*cice/2,':','Color','Red')
end

colormap(flipud(b2o2(-90,90)));

%%%%%%%%% First Implementation of the plot (gridded data)
row_indecies = find(min(isnan(slopegrid),[],2) == 0);
h = imagesc(slopegrid_x,slopegrid_y(row_indecies),slopegrid(row_indecies,:));
set(h,'Alphadata',~isnan(slopegrid(row_indecies,:))*0.3)
caxis([-90 90])

colorbar;


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


disp(['Line Complete'])


end