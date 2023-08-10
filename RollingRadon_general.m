function [slopegrid_x slopegrid_y slopegrid opt_x opt_y opt_angle] = RollingRadon_general(data_x,data_y,Data,window,plotter,movie_flag)


if exist('plotter') == 0
    plotter = 0;
    movie_flag = 0;
end

if exist('movie_flag') == 0
    movie_flag = 0;
end

if movie_flag == 1
    mkdir ./Animation_Frames/
end

o_f_horizontal = 15;
o_f_vertical = 10; % - Change this for enhanced Overlap of individual slope cells

snr_thresh = 0.00001; % - Change this for the SNR threshold (dB)
snr_fac = 10; % - Secondary SNR evaluation - the number of standard deviations below the mean power for the trace for a cutoff

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



dist = data_x;


if plotter == 1
    figure()
    set(gcf,'Position',[93  76  1003  667])
    subplot(3,4,[1 2 3 5 6 7 9 10 11])
    imagesc(data_x,data_y,Data)
    set(gca,'ydir','Normal')
    colormap(gray)
    hold all
    subplot(3,4,12)
    plot(1,3,'o','Color','red')
    hold all
    plot(1,2,'o','Color','blue')
    plot(1,1,'o','Color','green')
    text(2,4,'Calculated Slope','HorizontalAlignment','left')
    text(2,3,'Outside of Ice Column','HorizontalAlignment','left')
    text(2,2,'SNR too low','HorizontalAlignment','left')
    text(2,1,'Angle Variability Exceeded','HorizontalAlignment','left')
    color_opts = {'red','none','green'};
    axis off
    ylim([0 5])
    xlim([0 8])
    NDH_Style()
end


overload_factor = 1000; % This breaks the initial computation into cells smaller than the prescribed value, to save on memory

if length(Data(1,:)) > overload_factor
    steps = ceil(length(Data(1,:))/overload_factor);
    breaks = [1:overload_factor:(length(Data(1,:))+1) (length(Data(1,:))+1)];
else
    steps = 1;
    breaks = [1 length(Data(1,:))+1];
end

for k = 1:steps
    
    %% Initial Data Preconditioning:
    clearvars xaxis yaxis data
    
    %%%% THIS IS THE INTERPOLATION STEP! THIS IS CRITICAL TO THE PROPER
    %%%% FUNCTIONING OF THE CODE
    filt_data = Data(:,breaks(k):breaks(k+1)-1);
    [xaxis yaxis data] = regrid(dist(breaks(k):breaks(k+1)-1),data_y,filt_data,0,0);

    %% This determines if it is the first subset of the data, if so variables are initialized
    if exist('previous_xsteps') == 0
        previous_xsteps = 0;
    end
    roll_steps = round((length(data(1,:))-window_size)/xstep_roll + 1); %Horizontal Steps
    roll_steps2 = round((length(data(:,1))-window_size2)/ystep_roll + 1); %Vertical Steps

    
    slope_colors = flipud(b2r2(-90,90));
    slope_vals = -90:181/length(slope_colors(:,1)):90;
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
    
    for i = 1:roll_steps
        
        %% Determine the Window area for the horizontal dimension
        start = (i-1)*xstep_roll+floor(window_size/o_f_horizontal)+1;
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
        power_dist = conv(data(:,centerx_ind),ones(round(length(data(:,centerx_ind))/50),1),'same')./conv(ones(size(data(:,centerx_ind))),ones(round(length(data(:,centerx_ind))/50),1),'same');
        power_dist_mean = mean(power_dist);
        power_dist_std = std(power_dist);
        
        
        for j = 1:roll_steps2
            %% Determine the Window area for the vertical dimension
            start2 = (j-1)*ystep_roll + floor(window_size2/o_f_vertical)+1;
            stop2 = min([start2+window_size2-1 length(data(:,1))]);
            opt_y(j) = yaxis(stop2-floor((stop2-start2)/2));
            centery_ind = stop2-floor((stop2-start2)/2);
            if i > 1
                if opt_x(end) <= opt_x(end-1)
                    end_counter2 = end_counter2+1;
                    opt_x(end) = xaxis(stop2-floor((window_size2-1)/2)+end_counter2);
                else
                    end_counter2 = 0;
                end
            end
            skipflag = 0;

            %% If the window isn't skipped due to falling outside the ice column, the signal to noise criteria is tested
            if skipflag == 0;
                
                radon_data = data(start2:stop2,start:stop);
                means(j,i+(k-1)*roll_steps) = mean(mean(radon_data));
                
                %%% Compute Signal to Noise for final restriction
                snr_win_data = data(start2:stop2,centerx_ind);
                snr_std = std(snr_win_data);
                snr = 2*snr_std;

                %%% Tests the SNR Criterion
                if snr < snr_thresh | power_dist(centery_ind) < power_dist_mean - snr_fac*power_dist_std
                    opt_angle(j,i+(k-1)*roll_steps) = NaN;
                    skipflag = 1;
                    status_flag(j,i+(k-1)*roll_steps) = 2;
                else
                    try
                        [opt_angle(j,i+(k-1)*roll_steps) rd] = radon_ndh(xaxis(start:stop),yaxis(start2:stop2),radon_data,0,0);
                    catch
                        opt_angle(j,i+(k-1)*roll_steps) = NaN;
                        rd = NaN;
                    end
                    if isnan(opt_angle(j,i+(k-1)*roll_steps)) == 1
                        status_flag(j,i+(k-1)*roll_steps) = 2;
                    end
                end
            else
                opt_angle(j,i+(k-1)*roll_steps) = NaN;
            end
            
            %% If the Window still isn't skipped, this test makes sure the computed slopes don't vary dramatically over space
            %%%%% This doesn't seem to work so I'm commenting int out for
            %%%%% now
            %             if i ~= 1 | j~= 1
            %                 if abs(last_val-opt_angle(j,i+(k-1)*overload_factor)) > 5
            %                     last_val = opt_angle(j,i+(k-1)*overload_factor);
            %                     opt_angle(j,i) = NaN;
            %                     status_flag(j,i) = 3;
            %                 end
            %             else
            %                 last_val = opt_angle(j,i+(k-1)*overload_factor);
            %             end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% This section does the rolling plotter (for debug purposes)
            if plotter == 1
                
                subplot(3,4,[1 2 3 5 6 7 9 10 11])
                if i ~= 1 | j~= 1
                    delete(a)
                    if abs(last_val-opt_angle(j,i+(k-1)*roll_steps)) > 10
                        keep_val = 0;
                        last_val = opt_angle(j,i+(k-1)*roll_steps);
                        opt_angle(j,i+(k-1)*roll_steps) = NaN;
                    else
                        keep_val = 1;
                    end
                else
                    last_val = opt_angle(j,i+(k-1)*roll_steps);
                end
                a = plot([xaxis(start) xaxis(start) xaxis(stop) xaxis(stop) xaxis(start)],[yaxis(start2) yaxis(stop2) yaxis(stop2) yaxis(start2) yaxis(start2)],'Color','blue','LineWidth',2);
                
                if skipflag == 0 & isnan(opt_angle(j,i+(k-1)*roll_steps)) == 0 % If there was no value computed, it skips plotting the dot

                    tc = find_nearest(slope_vals,opt_angle(j,i+(k-1)*roll_steps));
                    plot(opt_x(i+(k-1)*roll_steps),opt_y(j),'o','MarkerFaceColor',slope_colors(tc,:),'Color',slope_colors(tc,:))
                    
                    
                    
                    subplot(3,4,4)
                    imagesc(radon_data)
                    title('Data Window')
                    subplot(3,4,8)
                    imagesc(rd)
                    title('Radon Transform')
                    
                    %             subplot(3,4,12)
                    %             xlim([-1 1])
                    %             ylim([-1 1])
                    %             namer = text(0,0,num2str(opt_angle(j,i+(k-1)*overload_factor)(j,i+(k-1)*overload_factor)));
                    pause(0.03)
                    %             delete(namer)
                    if movie_flag == 1
                        savename = ['./Animation_Frames/RRadon_Frame_',sprintf('%04d',counter1),'.jpg'];
                        print(savename,'-djpeg');
                        counter1 = counter1 + 1;
                    end
                    
                else
                    if status_flag(j,i+(k-1)*roll_steps)
                        plot(opt_x(i+(k-1)*roll_steps),opt_y(j),'o','Color',color_opts{status_flag(j,i+(k-1)*roll_steps)})
                        pause(0.01)
                    end
                end
            end
            %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        if round(100*i/roll_steps) >= updater
            t_input = clock;
            disp(['         RollStep Progress - ',num2str(i),'/',num2str(roll_steps),' ',num2str(round(100*i/roll_steps)),'% - ',num2str(t_input(4)),':',num2str(t_input(5)),':',num2str(t_input(6))])
            updater = updater+10;
        end
        
        
    end
    disp(['Window Progress ',num2str(k),'/',num2str(steps)])
    
    
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
end

%% Produce the final results image
zero_inds = find(opt_x ~= 0);
slope_x = opt_x(zero_inds);
slope_y = opt_y;
slopes = opt_angle(:,zero_inds);
means = means(:,zero_inds);



%%%% This filters out points whose slope values are more than +- 20
%%%% than their neighbor;
compare_grid = conv2(abs(NaN2value(slopes,0)),ones(3),'same');
nan_flag_values = find(abs(slopes) > abs(compare_grid/4.5) | slopes > 50);% | abs(slopes) < abs(compare_grid/18));
slopes(nan_flag_values) = NaN;

mask_vals = 1-[conv2(double(isnan(slopes)),ones(5),'same') > 13];
mask2 = [means > 0];
morethan4_adjacent_nans = find(mask_vals == 0);

slopes(morethan4_adjacent_nans) = 0;
slopes = slopes.*mask2;


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
interp_method = 3;
%1 - 1D interpolation in time for each slope column
%2 - 2D interpolation
%3 - Standard Grid regridding

if interp_method == 1
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
    opt_angle(find(isnan(opt_angle) == 1)) = 0;
    [slopegrid  slopegrid_x slopegrid_y] = regrid(opt_x,opt_y,opt_angle,data_x,data_y);   
    
end

slopegrid = slopegrid*-1;




disp('Writing Figure')


final_fig = figure();
set(final_fig,'Position',[1000 639 1400 699])
imagesc(dist,data_y,Data)
colormap(gray)
colorlock


colormap(flipud(b2o2(-90,90)));

%%%%%%%%% First Implementation of the plot (gridded data)
row_indecies = find(min(isnan(slopegrid),[],2) == 0);
h = imagesc(slopegrid_x,slopegrid_y(row_indecies),slopegrid(row_indecies,:));
set(h,'Alphadata',~isnan(slopegrid(row_indecies,:))*0.3)
caxis([-90 90])

colorbar;


disp(['Line Complete'])

