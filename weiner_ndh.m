%function [result filter] = weiner_ndh(amplitude,time,desired_wavelet,desired_wavelet_time,filt_duration,plotter);
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% Computes the 1D Weiner Filter, and filters the provided amplitude series
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
%  amplitude - the amplitude series that you wish to filter
%  time - the t-axis values for the amplitude series. If a 0 is provided,
%            the timing is assumed to be integer steps.
%  desired_wavelet - A desired wavelet for filter design. Filter size will
%            be determined by an autocorrelation analysis. Supplying a 0
%            will assume a spike.
%  desired_wavelet_time - The time series associated with that wavelet. If  
%            a 0 is provided, the wavelet time is assumed to be the first
%            available sample times
%  plotter - 0 or 1, 1 will plot the filtered results.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% %% Testing_Components
clear all
load lineout_4

time = time;
amplitude = ampdiff_amp(:,30);
desired_wavelet = 0;
desired_wavelet_time = 0;
plotter = 1;

if length(amplitude(:,1)) > 1
    amplitude = amplitude';
end

if exist('plotter') == 0
    plotter = 0;
end

if exist('time') == 0
    time = 0;
end
if time == 0;
    time = 1:length(amplitude);
end
if length(time(:,1)) > 1
    time = time';
end
time_scale = min(time);
time = time-time_scale;

if exist('desired_wavelet') == 0
    desired_wavelet = 0;
end
if desired_wavelet == 0;
    desired_wavelet = [1 0];
    desired_wavelet_time = 0;
end

if exist('desired_wavelet_time') == 0
    desired_wavelet_time = 0;
end
if desired_wavelet_time == 0
    desired_wavelet_time = time(1:length(desired_wavelet));
end

if exist('filt_duration') == 0
    filt_duration = 0;
end



% Zero padding the seismogram and desired wavelet
pad_amount = min([round(length(time)/10) 100]);
amplitude = [amplitude zeros(1,pad_amount)];
time = [time time(end)+(1:pad_amount)*(time(2)-time(1))];
desired_wavelet = [desired_wavelet 0 0]; % Adds zero values immediately following the end of the prescribed wavelet and at the max time (for dw calc)
desired_wavelet_time = [desired_wavelet_time desired_wavelet_time(end)+(time(2)-time(1)) max(time)];
dw = interp1(desired_wavelet_time,desired_wavelet,time); % Interpolate the desired wavelet onto the original time series.
[cors lags] = correlation(amplitude,[],time,[],0);

if filt_duration == 0
    a = figure(50);
    plot(lags,cors)
    ylabel('AutoCorrelation')
    xlabel('Lags')
    plot_indicator_lines(0,1,'black',1)
    plot_indicator_lines(0,2,'black',1)
    coord = graphical_selection(2);
    close gcf
else
    coord = filt_duration;
end

    end_index = find_nearest(time-min(time),coord(end,1),1) - find_nearest(time,0,1)+1;


for i = 1:end_index
    % Design the autocorrelation matrix for the filter design
    mat1(i,:) = cors(ceil(length(cors)/2)-i+1:ceil(length(cors)/2)+end_index-i);
end

% Construct the crosscorellation matrix for the inverse process
[mat2 lags2] = correlation(dw,amplitude,[],[],0,2);
figure()
plot(mat2,lags2)
keyboard

% Dealing with issues where the non-zero correlation values are not
% centered at 0;
if abs(min(lags2)) ~= max(lags2);
    temp_lags2 = -max([abs(min(lags2)) max(lags2)]):(lags2(2)-lags2(1)):max([abs(min(lags2)) max(lags2)]);
    temp_mat2 = zeros(1,length(temp_lags2));
    overlap = find_overlap(temp_lags2,lags2);
    temp_mat2(overlap(1):overlap(2)) = mat2;
    mat2 = temp_mat2;
    lags2 = temp_lags2;
end

zero_index = find_nearest(lags2,0);
mat2 = mat2(zero_index:zero_index+length(mat1(1,:))-1)';

filter = inv(mat1)*mat2;

[result result_time] = convolution(amplitude,filter,time,time(1:length(filter)),0);

time = time+time_scale;
result_time = result_time+time_scale;

if plotter == 1
    plot(time,amplitude,'Color','red')
    hold all
    plot(result_time,result,'Color','blue')
    plot(time,dw,':','Color','blue','LineWidth',2)
    legend({'Original Curve','Deconvolved Curve','Desired Wavelet'})
end
    

%end








