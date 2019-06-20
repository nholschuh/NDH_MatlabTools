function results = Time_Shift_XCorr(seis0,ta0,seis1,ta1,windows,maxlags,stretch_restriction,conditioned,plotter)
% (C) Nick Holschuh - Chevron Corporation - 2014 (Nick.Holschuh@gmail.com)
% This code performs time shift calculations using the cross-correlation
% method.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Index %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% seis0 - Seismic amplitudes for the baseline trace
% time_axis0 - The corresponding time scale
% seis1 - Seismic amplitudes for the monitor trace
% time_axis1 - The corresponding time scale
%
% windows - The crosscorrelation window size (in time). If not entered, you
%           will be prompted.
% maxlags - The maximum allowable time lag (in time). If not entered, you
%           will be prompted.
%
% stretch_restriction - limit to the difference in number of lags for
%                   adjacent samples (value provided in samples).
%
% conditioned - 0 or 1, turns on the total cross-correlation threshold, 
%               below which the computed lag is thrown out and set to 0.
%
% plotter - 0 (for no results plotting) or 1 (for results plotting)
%
%%%% results Breakdown
%
% nx3 matrix
% column 1 - Shifted Monitor Amplitudes
% column 2 - Time Shifts (in proper units)
% column 4 - Crosscorrelation value
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
tic
resolution = 10;
dt = ta0(2)-ta0(1);
newdt = (ta0(2)-ta0(1))/resolution;
debug = 1;


if exist('stretch_restriction') == 0;
    stretch_restriction = round(length(seis0)/20);
else
    stretch_restriction = round(stretch_restriction/newdt);
end

if exist('conditioned') == 0;
    conditioned = 0;
end

if exist('plotter') == 0
    plotter = 0;
end
if exist('windows') == 0 | windows == 0 
    prompt = ['Select Window Size (Sample Rate = ',num2str(dt),')'];
    windows = inputdlg(prompt);
    windows = str2num(windows{1});
end
if maxlags == 0
    prompt = ['Select Max Lag (Sample Rate = ',num2str(dt),')'];
    windows = inputdlg(prompt);
    windows = str2num(windows{1});
end

resolution = 10;


% Upsampling for restriction
ta0_compare = min(ta0):(ta0(2)-ta0(1))/resolution:max(ta0);
ta1_compare = min(ta1):(ta1(2)-ta1(1))/resolution:max(ta1);
seis0_compare = interp1(ta0,seis0,ta0_compare,'spline');
seis1_compare = interp1(ta1,seis1,ta1_compare,'spline');
start_index = 1:resolution:length(ta1_compare);


windows2 = floor(windows/dt);
if mod(windows2,2) == 0
    windows2 = windows2+1;
end



w_samples = round((windows2-1)*resolution)+1;
maxlags2 = round(maxlags/newdt);
lagrange_index = (-maxlags2:maxlags2);
lagrange_value = (-maxlags2:maxlags2)*newdt;


if mod(w_samples,2) == 0
    w_samples = w_samples+1;
end



loop_range = (windows2+1)/2:(length(seis0)-(windows2-1)/2)-1;



time_shifts = zeros(length(ta0),1);
lag_index = zeros(length(ta0),1);
lag_value = zeros(length(ta0),1);
xcor_val = zeros(length(ta0),1);
if conditioned == 0
    condition_remove = 1;
else
    condition_remove = 0;
end

store_xcors = zeros(441,length(ta0));

        counter = 1;
for i = loop_range
    
    window_centers = start_index(i);
    
    % Here we define the set of samples used in the baseline to
    % crosscorrelate with the monitor window (based on the max_lags
    % restriction)
    
    if max([window_centers-maxlags2-(w_samples-1)/2 1]) == 1
        seis0_range = 1:(window_centers + length(1:window_centers)-1);
    elseif min([window_centers+maxlags2+(w_samples-1)/2 length(seis0_compare)]) == length(seis0_compare)
        seis0_range = window_centers-(length(window_centers:length(seis0_compare)))+1:length(seis0_compare);
    else
        seis0_range = window_centers-maxlags2-(w_samples-1)/2:window_centers+maxlags2+(w_samples-1)/2;
    end
    
    seis1_range = window_centers-(w_samples-1)/2:window_centers+(w_samples-1)/2;
    xcorr_seis1 = zeros(length(seis0_range),1);
    mid = (length(seis0_range)+1)/2;
    if i == min(loop_range)
        prev_index = mid*2-1;
    end
    xcorr_seis1(mid-(length(seis1_range)-1)/2:mid+(length(seis1_range)-1)/2) = seis1_compare(seis1_range);
    [xcorr_temp xcorr_lags] = xcorr(seis0_compare(seis0_range),xcorr_seis1);
    store_xcors(1:length(xcorr_temp),i) = xcorr_temp;
    search_range = max([1 prev_index-stretch_restriction]):min([prev_index+stretch_restriction length(xcorr_temp)]);
    addition_fac = max([1 prev_index-stretch_restriction]);
    
    [t1] = find(max(xcorr_temp(search_range)) == xcorr_temp(search_range)) +addition_fac-1;
    if length(t1) > 1
        temp_ind = find_nearest(t1,mid);
    else
        temp_ind = 1;
    end
    lag_value(i) = xcorr_lags(t1(temp_ind));
    xcor_val(i) = xcorr_temp(t1(temp_ind));
    lag_index(i) = t1(temp_ind)-mid*2+1;
    
    if condition_remove == 0
        if xcor_val(i) < min(seis0)/1000
            lag_value(i) = 0;
            xcor_val(i) = 0;
            lag_index(i) = mid*2-1;
        else
            condition_remove = 1;
        end
    end
    
    
    if debug == 1
        %     %%% Debug stretch restriction
        subplot(2,1,1)
        hold off
        plot(seis0_range,seis0_compare(seis0_range),'Color','blue','LineWidth',3)
        hold all
        plot(seis0_range,xcorr_seis1,'LineWidth',2,'Color','red')
        %plot(seis1_range,seis1_compare(seis1_range),'LineWidth',2,'Color','red')
        ylim([-max(seis1) max(seis1)])
        ylabel('Amplitude')
        xlabel('Sample #')
        
        xcorr_lag_values = xcorr_lags*newdt;       
        subplot(2,1,2)
        hold off
        %plot(-(length(xcorr_temp)-1)/2:(length(xcorr_temp)-1)/2,xcorr_temp)
        plot([0 0],[-1.4 1.4],':','Color','black')
         hold all
        plot([lag_index(i)*newdt lag_index(i)*newdt],[-1.4 1.4],'Color','cyan')         
         
        plot(xcorr_lag_values,xcorr_temp/max(xcorr_temp),'Color','blue','LineWidth',2)


        plot(xcorr_lag_values(search_range),xcorr_temp(search_range)/max(xcorr_temp),'Color','red','LineWidth',2)
        plot(lag_index(i)*newdt,xcor_val(i)/max(xcorr_temp),'o','Color','red')
        xlim_val = max([abs(max(xcorr_lag_values)) abs(min(xcorr_lag_values))]);
        xlim([-1*xlim_val xlim_val])
    
        ylim([-1.4 1.4])
        
        ylabel('Cross Correlation Value (normalized)')
        xlabel('Lag')
        pause(0.01)

        mov(counter) = getframe(gcf);
        counter = counter+1;

        %     %%%
    end
    %%% Debug self-correlation noise
    if debug == 2
        if i > 20
            subplot(3,3,1:2)
            hold off
            plot(seis0_range,seis0_compare(seis0_range),'Color','blue','LineWidth',2)
            hold all
            plot(seis0_range,xcorr_seis1(),'LineWidth',3,'Color','red')
            plot(seis1_range+lag_index(i),seis0_compare(seis1_range+lag_index(i)),'o','Color','black')
            xcorr_testvalue_1 = round(sum(seis0_compare(seis0_range+lag_index(i))'.*xcorr_seis1())/1000);
            
            subplot(3,3,4:5)
            hold off
            plot(seis0_range,seis0_compare(seis0_range),'Color','blue')
            hold all
            plot(seis0_range,xcorr_seis1(),'LineWidth',2,'Color','red')
            xcorr_testvalue_2 = round(sum(seis0_compare(seis0_range)'.*xcorr_seis1())/1000);
            
            subplot(3,3,7:9)
            plot(lag_value(min(loop_range):i),'Color','black','LineWidth',2)
            xcorr_testvalue_1 = round(sum(seis0_compare(seis0_range+lag_index(i))'.*xcorr_seis1())/1000);
            
            
            [overlap] = find_overlap(seis0_range,seis0_range+lag_index(i));
            overlap_values = seis0_range(overlap(1):overlap(2));
            
            if lag_index(i) < 0
                %xctv1 = the overlapping portion of the
                %crosscorrelation for the 0 shift and non-zero shift
                xctv1 = round(sum(seis0_compare(overlap_values+lag_index(i))'.*xcorr_seis1(-lag_index(i)+1:end))/1000);
                %xctv3 =
                
                xctv3 = round(sum(seis0_compare(seis0_range+lag_index(i))'.*xcorr_seis1())/1000) - round(sum(seis0_compare(overlap_values+lag_index(i))'.*xcorr_seis1(-lag_index(i)+1:end))/1000);
                xctv2 = round(sum(seis0_compare(overlap_values)'.*xcorr_seis1(-lag_index(i)+1:end))/1000);
                xctv4 = round(sum(seis0_compare(seis0_range)'.*xcorr_seis1())/1000) - round(sum(seis0_compare(overlap_values)'.*xcorr_seis1(-lag_index(i)+1:end))/1000);
                
            else
                xctv1 = round(sum(seis0_compare(overlap_values+lag_index(i))'.*xcorr_seis1(1:length(xcorr_seis1)-lag_index(i)))/1000);
                xctv3 = round(sum(seis0_compare(seis0_range+lag_index(i))'.*xcorr_seis1())/1000) - round(sum(seis0_compare(overlap_values+lag_index(i))'.*xcorr_seis1(1:length(xcorr_seis1)-lag_index(i)))/1000);
                xctv2 = round(sum(seis0_compare(overlap_values)'.*xcorr_seis1(1:length(xcorr_seis1)-lag_index(i)))/1000);
                xctv4 = round(sum(seis0_compare(seis0_range)'.*xcorr_seis1())/1000) - round(sum(seis0_compare(overlap_values)'.*xcorr_seis1(1:length(xcorr_seis1)-lag_index(i)))/1000);
            end
            
            
            diff_1 = xctv1-xctv2;
            diff_2 = xctv3-xctv4;
            diff_3 = diff_2+diff_1;
            diff_4 = xcorr_testvalue_1 - xcorr_testvalue_2;
            
            
            
            
            subplot(3,3,3)
            hold off
            a = text(-0.5,0.5,num2str(xcorr_testvalue_1),'HorizontalAlignment','center','FontSize',16);
            b = text(-0.5,-0.5,num2str(xcorr_testvalue_2),'HorizontalAlignment','center','FontSize',16);
            c = text(0.5,0,num2str(diff_4),'HorizontalAlignment','center','FontSize',16);
            ylim([-1 1])
            xlim([-1 1])
            subplot(3,3,6)
            hold off
            d = text(-0.5,0.5,num2str(diff_1),'HorizontalAlignment','center','FontSize',16);
            e = text(-0.5,-0.5,num2str(diff_2),'HorizontalAlignment','center','FontSize',16);
            f = text(0.5,0,num2str(diff_3),'HorizontalAlignment','center','FontSize',16);
            ylim([-1 1])
            xlim([-1 1])
            pause(1)
            delete(a,b,c,d,e,f)
        end
        
        
    end
    %     %%%
    
    if condition_remove == 0
        prev_index = mid*2-1;
    else
        prev_index = t1(temp_ind);
    end
    
end

if debug == 1;
    movie2avi(mov, 'TShift_XCorr_debug.avi', 'compression', 'None');
end

%%%% Apply the time-shift
if length(lag_index(1,:)) ~= length(lag_index(:,1))
    lag_index = lag_index';
end

newtimes = start_index - lag_index;

for i = 2:length(newtimes)
    if newtimes(i-1) > newtimes(i)
        newtimes(i) = newtimes(i-1)+1;
    end
end

shifted_seis1 = interp1(start_index,seis1_compare(start_index),newtimes,'spline');





%%%% Code necessary for correct plotting
if length(shifted_seis1(1,:)) > 1
    shifted_seis1 = shifted_seis1';
end

if length(seis0(1,:)) > 1
    seis0 = seis0';
    seis1 = seis1';
end

if length(lag_value(1,:)) > 1
    lag_value = lag_value';
end

if length(xcor_val(1,:)) > 1
    xcor_val = xcor_val';
end


for i = 1:length(lag_value)
    lag_value_real(i) = lagrange_value(lag_index(i)+(length(lagrange_value)-1)/2);
end
lag_value_real = lag_value_real';


results = [shifted_seis1 lag_value_real xcor_val];

if plotter == 1
    figure()
    
    columns = 6;
    rows_num = 2;
    
    a = subplot(rows_num,columns,1:3);
    plot(ta0,seis0,'Color','black','LineWidth',2)
    hold all
    plot(ta1,seis1,'Color','blue','LineWidth',2)
    xlabel('Two-way Travel Time (s)')
    ylabel('Amplitude (normalized to source)')
    
    fitrow = 1;
    d = subplot(rows_num,columns,fitrow*columns + (1:3));
    plot(ta0,shifted_seis1,'o','Color','blue')
    hold all
    plot(ta0,seis0,'Color','black','LineWidth',4)
    plot(ta0,seis0,'Color','white','LineWidth',1)
    xlabel('Two-way Travel Time (s)')
    ylabel('Amplitude (normalized to source)')
    
    linkaxes([a d],'x')
    colorscaler = 1;
    
    cmap = b2r(-1e6,1e6);
    
    if length(seis1) > length(seis0)
        colorscaler = max(seis1(1:length(seis0))-seis0);
    else
        colorscaler = max(seis1-seis0(1:length(seis1)));
    end
    
    subplot(rows_num,columns,[columns*(1:rows_num)-2]);
    imagesc(0,ta0,shifted_seis1-seis0)
    caxis([-colorscaler colorscaler])
    colormap(cmap)
    title('Amp Differences - Time-Shifted')
    
    subplot(rows_num,columns,[columns*(1:rows_num)-1]);
    if length(seis1) > length(seis0)
        imagesc(0,ta1,seis1(1:length(seis0))-seis0)
        caxis([-colorscaler colorscaler])
        colormap(cmap)
        title('Amp Differences - raw')
    else
        imagesc(0,ta1,seis1-seis0(1:length(seis1)))
        caxis([-colorscaler colorscaler])
        colormap(cmap)
        title('Amp Differences - raw')
    end
    
    subplot(rows_num,columns,[columns*(1:rows_num)]);
    plot(lag_value_real,ta0,'LineWidth',2,'Color','black')
    xlim([-0.1 0.1])
    set(gca,'YDir','reverse')
    title('Time Shift (s)')
end


toc
pause(0.01)

end