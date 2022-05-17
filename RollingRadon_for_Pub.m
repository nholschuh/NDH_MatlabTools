function [slopegrid_x slopegrid_y slopegrid opt_x opt_y opt_angle] = RollingRadon( ...
    data_x_or_filename,data_y,Data,window,angle_thresh, ...
    plotter,surface_bottom,movie_flag,max_frequency)
% (C)Nick Holschuh - Penn State University - 2016 (Nick.Holschuh@gmail.com)
% Performs the rolling radon transform slope analysis on a set of data
% {optimized for the CReSIS data format, but can be used for any data).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% data_x_or_filename - Either the X-axis or the name of a CReSIS flight
%                      file (x-axis in distance)
% data_y - values for the Y-axis ***(ignored if filename provided)
%          this can be either a twtt or depth
% Data - the data raster         ***(ignored if filename provided)
% window - this defines the size of the rolling window
% angle_thresh - this value is the maximum slope useable;
% plotter - 1, generates the debug plots
% [surface_bottom] - a vector containing the surface and bottom picks
% [movie_flag] - 1, Records the debug plots (must have plotter == 1)
% [max_frequency] - this sets the scale for interpolation, based on the
%                 highest frequency of interest in the data. Can induce
%                 memory problems, and not required.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initial Parameter Setup:
% Change this for enhanced Overlap of individual slope cells
o_f_vertical = 6;
o_f_horizontal = 2;
% Change this for the SNR threshold (dB)
snr_thresh = 2;
% Secondary SNR evaluation - the number of standard deviations
snr_fac = 1;            %  below the mean power for the trace for a cutoff
% The rate at which the debug plotter updates
pr = 0.1;
% This sets how many samples in a row need to deviate before the
% code recognizes it is actually a new value
vr = 3;


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

clearvars -except Data dist data_y Surface Bottom window_size ...
    window_size2 o_f_vertical o_f_horizontal snr_thresh plotter ...
    movie_flag snr_fac max_frequency xstep_roll ystep_roll ...
    angle_thresh pr vr

cice = 1.68*10^8;


%% Initiate the plotting
if plotter == 1
    subplot(3,4,[1 2 3 5 6 7 9 10 11])
    if exist('max_frequency') == 1 & abs(data_y(2)-data_y(1)) < 1e-4
        cice_import
        imagesc(dist,data_y*cice/2,Data);
    else
        imagesc(dist,data_y,Data)
    end
    colormap(gray)
    hold all
    if exist('Bottom') == 1
        plot(dist,Surface/2,':','Color','Blue')
        plot(dist,Bottom/2,':','Color','Red')
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
    color_opts = {'red','none','green'};
    ylim([0 5])
    xlim([0 8])
end


% This breaks the initial computation into cells smaller
% than the prescribed value, to save on memory
overload_factor = 1000;

if length(Data(1,:)) > overload_factor
    steps = ceil(length(Data(1,:))/overload_factor);
    breaks = [1:overload_factor:(length(Data(1,:))+1) (length(Data(1,:))+1)];
else
    steps = 1;
    breaks = [1 length(Data(1,:))];
end


slope_colors = b2r2(-angle_thresh(1),angle_thresh(2));
slope_vals = -angle_thresh(1): ...
    (2*angle_thresh(1)+1)/length(slope_colors(:,1)):angle_thresh(1);
total_time = 0;

for k = 1:steps
    %%%% Update to the console
    disp(['Starting Window ',num2str(k),' of ',num2str(steps), ...
        ', Total Time - ',sprintf('%.02f',total_time),' min'])
    
    %% Data Preconditioning:
    clearvars xaxis yaxis data
    
    
    
    %%%% THIS IS THE INTERPOLATION STEP! THIS IS CRITICAL TO THE PROPER
    %%%% FUNCTIONING OF THE CODE
    filt_data = Data(:,breaks(k):breaks(k+1)-1);
    if exist('max_frequency') == 1
        [ xaxis yaxis data] = regrid(dist(breaks(k):breaks(k+1)-1), ...
            data_y,filt_data,1,max_frequency);
        time = yaxis;
        if abs(yaxis(2)-yaxis(1)) < 1e-4
            yaxis = yaxis*cice/2;
        end
    else
        [ xaxis yaxis data] = regrid(dist(breaks(k):breaks(k+1)-1), ...
            data_y,filt_data,0,0);
        time = yaxis;
    end
    
    if exist('Bottom') == 1
        Bottom2 = interp1(dist(breaks(k):breaks(k+1)-1), ...
            interpNaN(Bottom(breaks(k):breaks(k+1)-1)),xaxis);
        Surface2 = interp1(dist(breaks(k):breaks(k+1)-1), ...
            interpNaN(Surface(breaks(k):breaks(k+1)-1)),xaxis);
    end
    
    %%% This determines if it is the first subset of the data,
    %%% if so variables are initialized
    if exist('previous_xsteps') == 0
        previous_xsteps = 0;
    end
    
    %%% Horizontal Steps
    if k < steps
        roll_steps = round((length(data(1,:))-window_size)/xstep_roll);
    else
        roll_steps = floor((length(data(1,:))-window_size)/xstep_roll);
    end
    %%% Vertical Steps
    roll_steps2 = round((length(data(:,1))-window_size2)/ystep_roll);
    
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
    
    %% Begin the rolling window
    for i = 1:roll_steps
        
        %%% Restart the variability record
        variability_record = [];
        last_val = [];
        
        %%% Determine the Window area for the horizontal dimension
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
        power_dist = conv(data(:,centerx_ind), ...
            ones(round(length(data(:,centerx_ind))/50),1),'same')./ ...
            conv(ones(size(data(:,centerx_ind))), ...
            ones(round(length(data(:,centerx_ind))/50),1),'same');
        power_dist_mean = mean(power_dist);
        power_dist_std = std(power_dist);
        
        
        for j = 1:roll_steps2
            %%% Determine the Window area for the vertical dimension
            start2 = (j-1)*floor(window_size2/o_f_vertical)+1;
            stop2 = min([(j-1)*floor(window_size2/o_f_vertical) + ...
                window_size2 length(data(:,1))]);
            opt_y(j) = yaxis(stop2-floor((stop2-start2)/2));
            centery_ind = stop2-floor((stop2-start2)/2);
            
            %%% If window falls between the bed and surface, continue, otherwise skip
            if i > 1
                if opt_x(end) <= opt_x(end-1)
                    end_counter2 = end_counter2+1;
                    opt_x(end) = xaxis(stop2-floor((window_size2-1)/2)+end_counter2);
                else
                    end_counter2 = 0;
                end
            end
            
            if exist('Bottom') == 1
                if time(centery_ind) < Bottom2(centerx_ind) & ...
                        time(centery_ind) > Surface2(centerx_ind)
                    skipflag = 0;
                else
                    skipflag = 1;
                    status_flag(j,i+previous_xsteps) = 1;
                end
            else
                skipflag = 0;
            end
            
            %%% If the window isn't skipped due to falling outside the ice
            %%% column, the signal to noise criteria is tested
            if skipflag == 0;
                
                radon_data = data(start2:stop2,start:stop);
                means(j,i+previous_xsteps) = mean(mean(radon_data));
                
                %% Compute the signal to noise ratio within the rolling window
                snr_win_data = data(start2:stop2,centerx_ind);
                snr_std = std(snr_win_data);
                snr = 2*snr_std;
                
                %%% Tests the SNR Criterion
                if snr < snr_thresh | power_dist(centery_ind) < ...
                        power_dist_mean - snr_fac*power_dist_std
                    opt_angle(j,i+previous_xsteps) = NaN;
                    skipflag = 1;
                    status_flag(j,i+previous_xsteps) = 2;
                else
                    
                    if length(xaxis(start:stop)) == 0
                        keyboard
                    end
                    
                    %% Compute the Radon transform
                    [opt_angle(j,i+previous_xsteps) rd trash trash rsnr] = ...
                        radon_ndh(xaxis(start:stop),yaxis(start2:stop2), ...
                        radon_data,angle_thresh(1),0,0);
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
            
            
            %% Excludes values that vary too dramatically over space
            %%% If the Window still isn't skipped, this test makes sure the
            %%% computed slopes don't vary dramatically over space
            if skipflag == 0
                variability_thresh = 4;
                %%% Only initiates after the first row
                if j~= 1 && ~isempty(last_val) && isnan(last_val) ~= 1
                    if abs(last_val-opt_angle(j,i+previous_xsteps)) > ...
                            variability_thresh
                        variability_record = [variability_record ...
                            opt_angle(j,i+previous_xsteps)];
                        %%% If five in a row don't fit the smoothness constraint,
                        %%% it accepts those values instead and starts over
                        if length(variability_record) >= vr;
                            opt_angle(j-vr+1:j,i+previous_xsteps) = ...
                                variability_record(1:vr);
                            last_val = opt_angle(j,i+previous_xsteps);
                            status_flag(j-vr+1:j,i+previous_xsteps) = 3;
                        else
                            opt_angle(j,i+previous_xsteps) = last_val;
                            last_val = opt_angle(j,i+previous_xsteps);
                            status_flag(j,i+previous_xsteps) = 3;
                        end
                    else
                        variability_record = [];
                    end
                else
                    last_val = opt_angle(j,i+previous_xsteps);
                    variability_record = [];
                end
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% This section does the rolling plotter (for debug purposes)
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
                a = plot([xaxis(start) xaxis(start) xaxis(stop) ...
                    xaxis(stop) xaxis(start)],[yaxis(start2) ...
                    yaxis(stop2) yaxis(stop2) yaxis(start2) ...
                    yaxis(start2)],'Color','blue','LineWidth',2);
                
                % If there was no value computed, it skips plotting the dot
                if skipflag == 0 & isnan(opt_angle(j,i+previous_xsteps)) == 0
                    tc = find_nearest(slope_vals,opt_angle(j,i+previous_xsteps));
                    plot(opt_x(i+previous_xsteps),opt_y(j),'o', ...
                        'MarkerFaceColor',slope_colors(tc,:), ...
                        'Color',slope_colors(tc,:))
                    
                    subplot(3,4,4)
                    hold off
                    imagesc(radon_data)
                    title(['Data Window - SNR ',sprintf('%.02f',snr)])

                    plot_indicator_lines( ...
                        [tan(deg2rad(-opt_angle(j,i+previous_xsteps))) ...
                        length(radon_data)/2 length(radon_data)/2],3,'blue')                   
                    
                    subplot(3,4,8)
                    hold off
                    imagesc(rd)
                    hold all
                    
                    title(['Radon Transform - RSNR',sprintf('%.02f',rsnr)])
                    pause(pr)
                    
                    if movie_flag == 1
                        savename = ['./Animation_Frames/RRadon_Frame_', ...
                            sprintf('%04d',counter1),'.jpg'];
                        print(savename,'-djpeg');
                        counter1 = counter1 + 1;
                    end
                    
                else
                    if status_flag(j,i+previous_xsteps)
                        plot(opt_x(i+previous_xsteps),opt_y(j),'o','Color', ...
                            color_opts{status_flag(j,i+previous_xsteps)})
                        pause(pr)
                    end
                end
            end
            %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        if round(100*i/roll_steps) >= updater
            disp(['         RollStep Progress - ',num2str(i),'/', ...
                num2str(roll_steps),' ',num2str(round(100*i/roll_steps)), ...
                '%, ',sprintf('%0.2f',toc/60),' minutes'])
            updater = updater+10;
        end
        
        
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


%%% Interpolate the Grid
disp('Writing Data')


slopegrid_x = opt_x;
slopegrid_y = opt_y;
slopegrid = opt_angle;

disp(['Line Complete'])


end