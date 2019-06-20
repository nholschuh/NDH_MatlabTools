function result = decon_ndh(amplitude,time,desired_wavelet,desired_wavelet_time,plotter);
%%



%% Testing_Components
% clear all
% time = 0:0.1:2*pi;
% amplitude = sin(time);
%  desired_wavelet = sin(time/2);
%  desired_wavelet_time = time;
% plotter = 1;
% 
% clear all
% time = 0:0.1:2*pi;
% amplitude = [sin(time) zeros(1,length(0:0.1:3*pi)) -0.6*sin(time)];
% time = (1:length(amplitude))*0.1-0.1;
% plotter = 1;

 
 
plotter = 1;



if exist('plotter') == 0
    plotter = 0;
end



% Zero padding the seismogram and desired wavelet
pad_amount = min([round(length(time)/5) 100]);
amplitude = [amplitude zeros(1,pad_amount)];
time = [time time(end)+(1:pad_amount)*(time(2)-time(1))];



a = figure(50);
[cors lags] = correlation(amplitude,[],time,[],0);
plot(lags,cors)
plot_indicator_lines(0,1,'black',1)
plot_indicator_lines(0,2,'black',1)
coord = graphical_selection(2);


    
% The solution for predictive deconvolution
if length(coord(:,1)) > 1
    start_index = find_nearest(time,coord(1,1),1) - find_nearest(time,0,1)+1;
    end_index = find_nearest(time,coord(end,1),1) - find_nearest(time,0,1)+1;
    dw_length = end_index-start_index+1;
    desired_wavelet = zeros(1,end_index);
    desired_wavelet(1:dw_length) = amplitude(start_index:end_index);
    desired_wavelet_time = time(1:end_index);
    desired_wavelet = [desired_wavelet 0 0];
    desired_wavelet_time = [desired_wavelet_time desired_wavelet_time(end)+(time(2)-time(1)) max(time)];
    dw = interp1(desired_wavelet_time,desired_wavelet,time);
% The solution for spiking deconvolution
else
    desired_wavelet = [desired_wavelet 0 0];
    desired_wavelet_time = [desired_wavelet_time desired_wavelet_time(end)+(time(2)-time(1)) max(time)];
    dw = interp1(desired_wavelet_time,desired_wavelet,time);
    end_index = find_nearest(time,coord(end,1),1) - find_nearest(time,0,1)+1;
end
close gcf





for i = 1:end_index
    % Design the autocorrelation matrix for the filter design
    mat1(i,:) = cors(ceil(length(cors)/2)-i+1:ceil(length(cors)/2)+end_index-i);
end

% Construct the crosscorellation matrix for the inverse process
[mat2 lags2] = correlation(dw,amplitude,time,time,0);

% Dealing with issues where the non-zero correlation values are not
% centered at 0;
if abs(min(lags2)) ~= max(lags2);
    temp_lags2 = -max([abs(min(lags2)) max(lags2)]):(lags2(2)-lags2(1)):max([abs(min(lags2)) max(lags2)]);
    temp_mat2 = zeros(1,length(temp_lags2)*2);
    overlap = find_overlap(temp_lags2,lags2);
    temp_mat2(overlap(1):overlap(2)) = mat2;
    mat2 = temp_mat2;
    lags2 = temp_lags2;
end

zero_index = find_nearest(lags2,0);
mat2 = mat2(zero_index:zero_index+length(mat1(1,:))-1)';

filter = inv(mat1)*mat2;

[result result_time] = convolution(amplitude,filter,time,time(1:length(filter)),0);

dw_time = time;

% If predictive Decon
if length(coord(:,1)) > 1
    result_time = result_time+time(start_index-1);
    amp2_time = time(1):(time(2)-time(1)):max(result_time);
    amp2 = zeros(1,length(amp2_time));
    amp2(1:length(amplitude)) = amplitude;
    overlap2 = find_overlap(amp2_time,result_time);
    result2 = amp2;
    result2(overlap2(1):overlap2(2)) = result2(overlap2(1):overlap2(2)) - result;
    result = result2;
    result_time = amp2_time;
    
    dw = amp2;
    dw(overlap2(1):overlap2(2)) = zeros(1,length(dw(overlap2(1):overlap2(2))));
    dw_time = amp2_time;
end

if plotter == 1
    plot(time,amplitude,'Color','red')
    hold all
    plot(dw_time,dw,':','Color','blue','LineWidth',3)
        plot(result_time,result,'Color','black','LineWidth',3)
end
    

end








