function [result lags] = correlation(series1,series2,xaxis1,xaxis2,plotter,method)
% (C) Nick Holschuh - Penn State University - 2013 (Nick.Holschuh@gmail.com)
% Calculates the cross correlation of series1 and series2 (if no series2 is
% included, it calculates the autocorrelation of series1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The inputs are as follows:
%
% series1 - The first series to be cross-correlated (or the series to be
% autocorrelated)
%
% series2 - The second series to be cross-correlated
%
% plotter - If set to 1, Plots the series sliding and xcorr values, if set
% to 2, records a video of the process
%
% method - if set to 1, selects all non-zero values of the autocorrelation.
% If set to 2, it keeps all values that fall in the positions of the
% original series 1.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


series1 = NaN2value(series1,0); % Remove NaNs

pause_time = 0.01;

if exist('plotter') == 0
    plotter = 0;
end
if exist('method') == 0
    method = 1;
end

if exist('xaxis1') == 0 % Sets up unit axes if none are supplied
    xaxis1 = 0:length(series1)-1;
    if exist('series2') == 1
        xaxis2 = 0:length(series2)-1;
    end
elseif isempty(xaxis1) == 1
    xaxis1 = 0:length(series1)-1;
    if exist('series2') == 1
        xaxis2 = 0:length(series2)-1;
    end
end

if exist('series2') == 0 % Performs autocorrelation if only 1 series is provided
    series2 = series1;
    xaxis2 = xaxis1;
elseif isempty(series2) == 1
    series2 = series1;
    xaxis2 = xaxis1;
else
    series2 = NaN2value(series2,0);
end



correlation_vec = [];

%% Ensures the vectors are both horizontal vectors
if length(series1(:,1)) > 1
    series1 = series1';
end
if length(series2(:,1)) > 1
    series2 = series2';
end

dim_to_cat = find(size(xaxis1) > 1);
dx = abs(xaxis1(2)-xaxis1(1));

% Dealing with time axis not starting at 0 (both positive and negative)
final_xmax = max(abs([max(cat(dim_to_cat,xaxis1,xaxis2)) min(cat(dim_to_cat,xaxis1,xaxis2))]));
xaxis = min([0 -final_xmax]):dx:final_xmax;
overlap1 = find_overlap(xaxis,xaxis1);
overlap2 = find_overlap(xaxis,xaxis2);

if length(overlap2) ~= length(series2)
    overlap2 = overlap2(2)+1;
end

series1_temp = zeros(1,length(xaxis));
series2_temp = zeros(1,length(xaxis));
series1_temp(overlap1) = series1;
series2_temp(overlap2) = series2;
series1 = series1_temp;
series2 = series2_temp;

%% Fills out the vectors to facilitate calculation

lag_num = length(series1)-1;
overlap_range = length(series2);

series1_orig = series1;
series1 = [zeros(1,length(series2)-1) series1 zeros(1,length(series2)-1)];
series2 = [series2];

dt = xaxis1(2)-xaxis1(1);

lags = [(-lag_num)*dt:dt:(lag_num)*dt];

for i = 1:length(lags)
    vec1 = series1(i:(i+overlap_range-1));
    vec2 = series2;
    correlation_vec(i) = sum(vec1.*vec2);
end




if plotter >= 1;
    figure()
   
    
    corr_max = max(abs(correlation_vec));
    %vec_for_sum_max = max(max(abs(vec_for_sum)));
    
    optimal_lag_index = find(max(correlation_vec) == correlation_vec);
    zero_lag_index = find(0 == lags);
    for i = zero_lag_index:length(lags)
        vec1 = series1(i:(i+overlap_range-1));
        vec2 = series2;
        vec_for_sum(:,i) = vec1.*vec2;
        
        correlation_vec(i) = sum(vec_for_sum(:,i));
     

        subplot(2,1,1)
        hold off
        plot(xaxis,vec2,'o-','Color','black','LineWidth',2,'Color','black')
        hold all
        plot(xaxis,vec1,'o-','MarkerFaceColor','red')
        ylim(real([min([series1 series2])-2 max([series1 series2])+2]))
        xlim([min(xaxis) max(xaxis)])
        
        subplot(2,1,2)
        hold off
        plot([0 0],[-corr_max corr_max],':','Color','black')
        hold all
        %plot(xaxis,series1_orig,'.','Color','red')
        plot(lags(1:i),correlation_vec(1:i),'Color','black','LineWidth',2)
        plot(lags(i),correlation_vec(i),'o-','Color','black','MarkerFaceColor','black')
        
        if i >= optimal_lag_index
            %plot(lags(optimal_lag_index),correlation_vec(optimal_lag_index),'ro','MarkerFaceColor','red');
        end
        
        xlim([0 lags(end)])
        ylim([-corr_max-2 corr_max+2])
        %xlabel('Lag (samples)')
        %ylabel('Correlation Value')
        ylabel('(f \ast g)')
        
        set(gcf,'Color','white')
        pause(pause_time)
        if plotter == 2
            generate_frames('CorrExample','CorrExample',i);
        end
        
    end
end


if plotter == 2
    animate_frames('CorrExample','CorrExample',100,0,zero_lag_index,length(lags));
end

result = correlation_vec;
if method == 1
    keepers = find(result ~= 0);
    lags = lags(min(keepers):max(keepers));
    result = result(min(keepers):max(keepers));
elseif method == 1
    keepers = find_overlap(xaxis,xaxis1);
    lags = lags(min(keepers):max(keepers));
    result = result(min(keepers):max(keepers));
end
